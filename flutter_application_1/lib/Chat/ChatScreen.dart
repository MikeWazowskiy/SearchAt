import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/Profile/ProfileToCheck.dart';
import 'package:flutter_application_1/Users/users_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  ChatScreen({required this.receiverId, required this.receiverName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late Timer _timer;
  final ValueNotifier<List<XFile>> _selectedImages =
      ValueNotifier<List<XFile>>([]);

  final TextEditingController _messageController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String? receiverPhotoUrl;
  String? status;
  final UserManagement _userManagement = UserManagement();
  final ValueNotifier<String?> replyToMessage = ValueNotifier<String?>(null);
  final ValueNotifier<String?> replyToMessageTextVariable =
      ValueNotifier<String?>(null);
  late ScrollController _scrollController;
  List<DocumentSnapshot> messages = [];
  final ValueNotifier<String?> statusTextNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<bool> isOnlineNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
        this); // Добавляем наблюдателя за изменениями жизненного цикла
    _scrollController = ScrollController();
    getUserPhotoUrl(widget.receiverId);
    getUserStatusStream(widget.receiverId).listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        status = data['status'] ?? '';
        final newText = getTimeDifferenceString(status!);
        statusTextNotifier.value = newText;
        isOnlineNotifier.value = newText == 'online';
      }
    });
    _scrollController.addListener(_scrollListener);
    startTimer();
    _userManagement.updateUserCurrentChat(
        currentUser!.email!, getChatId(currentUser!.email!, widget.receiverId));
    markMessagesAsRead();
    _scrollToBottom();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(
        this); // Удаляем наблюдателя за изменениями жизненного цикла
    _scrollController.dispose();
    _messageController.dispose();
    replyToMessage.dispose();
    replyToMessageTextVariable.dispose();
    _timer.cancel();
    _scrollController.removeListener(_scrollListener);
    _userManagement.clearUserCurrentChat(currentUser!.email!);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startTimer();
    } else if (state == AppLifecycleState.paused) {
      _timer.cancel();
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      _selectedImages.value = List.from(_selectedImages.value)..addAll(images);
    }
  }

  void _removeImage(int index) {
    _selectedImages.value = List.from(_selectedImages.value)..removeAt(index);
  }

  Future<List<String>> _uploadImages(List<XFile> images, String chatId) async {
    List<String> downloadUrls = [];
    for (var image in images) {
      final ref =
          FirebaseStorage.instance.ref().child('chats/$chatId/${image.name}');
      await ref.putFile(File(image.path));
      final downloadUrl = await ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }
    return downloadUrls;
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      final currentStatus = status;
      if (currentStatus != null && currentStatus != 'online') {
        final newText = getTimeDifferenceString(currentStatus);
        if (statusTextNotifier.value != newText) {
          statusTextNotifier.value = newText;
        }
        _userManagement.updateUserCurrentChat(currentUser!.email!,
            getChatId(currentUser!.email!, widget.receiverId));
      }
    });
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      markMessagesAsRead();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        Future.delayed(Duration(milliseconds: 310), () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    });
  }

  void _scrollToMessage(String messageId) {
    final index = messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      final position = index * 72.0;
      _scrollController.animateTo(
        position,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<UserInfoToProfile?> getUserData(String userEmail) async {
    try {
      var userDocs = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();
      if (userDocs.docs.isNotEmpty) {
        var userData = userDocs.docs[0].data();
        return UserInfoToProfile(
          name: userData['name'],
          photoURLPath: userData['photoUrl'],
          email: userData['email'],
          aboutYourself: userData['about_yourself'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  void clearReply() {
    replyToMessage.value = null;
    replyToMessageTextVariable.value = null;
  }

  void cancelReply() {
    clearReply();
  }

  void setReplyMessage(String messageId, String messageText) {
    replyToMessage.value = messageId;
    replyToMessageTextVariable.value = messageText;
  }

  void getUserPhotoUrl(String userEmail) async {
    try {
      var userDocs = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();
      if (userDocs.docs.isNotEmpty) {
        setState(() {
          receiverPhotoUrl = userDocs.docs[0].data()['photoUrl'];
        });
      }
    } catch (e) {
      print('Error getting user photo URL: $e');
    }
  }

  Stream<DocumentSnapshot> getUserStatusStream(String userEmail) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.first);
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty ||
        _selectedImages.value.isNotEmpty) {
      final chatId = getChatId(currentUser!.email!, widget.receiverId);
      final receiverEmail = widget.receiverId;
      String? currentChatId;

      final receiverQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: receiverEmail)
          .get();

      if (receiverQuerySnapshot.docs.isNotEmpty) {
        final receiverDoc = receiverQuerySnapshot.docs.first;
        currentChatId = receiverDoc['currentChatId'];
      }

      final isChecked = currentChatId == chatId;

      await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
        'chatId': chatId,
        'users': [currentUser!.email, receiverEmail],
        'lastMessage':
            _messageController.text.isEmpty ? 'photo' : _messageController.text,
        'lastTimestamp': FieldValue.serverTimestamp(),
      });

      List<String> imageUrls = [];
      if (_selectedImages.value.isNotEmpty) {
        imageUrls = await _uploadImages(_selectedImages.value, chatId);
      }

      await FirebaseFirestore.instance.collection('messages').add({
        'chatId': chatId,
        'senderEmail': currentUser!.email,
        'receiverEmail': receiverEmail,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'isChecked': isChecked,
        'replyToMessage': replyToMessage.value,
        'edited': false,
        'imageUrls': imageUrls,
      });

      _messageController.clear();
      _selectedImages.value = [];
      _scrollToBottom();
      clearReply();
    }
  }

  String getChatId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode ? '$user1-$user2' : '$user2-$user1';
  }

  void markMessagesAsRead() async {
    final chatId = getChatId(currentUser!.email!, widget.receiverId);
    final unreadMessages = await FirebaseFirestore.instance
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .where('receiverEmail', isEqualTo: currentUser!.email)
        .where('isChecked', isEqualTo: false)
        .get();
    for (var doc in unreadMessages.docs) {
      await doc.reference.update({'isChecked': true});
    }
  }

  void deleteMessage(String messageId, String chatId) async {
    try {
      final messageDoc = await FirebaseFirestore.instance
          .collection('messages')
          .doc(messageId)
          .get();

      if (messageDoc.exists) {
        final data = messageDoc.data();
        if (data != null && data.containsKey('imageUrls')) {
          final imageUrls = List<String>.from(data['imageUrls'] ?? []);

          // Логируем количество изображений и само сообщение
          print(
              'Found ${imageUrls.length} images to delete in message: $data.');

          // Удаляем сообщение
          await FirebaseFirestore.instance
              .collection('messages')
              .doc(messageId)
              .delete();

          // Если у сообщения есть фотографии, удаляем их
          if (imageUrls.isNotEmpty) {
            for (final imageUrl in imageUrls) {
              try {
                final imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
                await imageRef.delete();
                print('Deleted image: $imageUrl');
              } catch (e) {
                print('Failed to delete image: $imageUrl, error: $e');
              }
            }
          }
        } else {
          print('No imageUrls found in message: $data.');
        }
      } else {
        // Если поле imageUrls не существует, удаляем только сообщение
        await FirebaseFirestore.instance
            .collection('messages')
            .doc(messageId)
            .delete();
        print('Message deleted without images.');
      }

      // Обновляем последнее сообщение чата
      final remainingMessages = await FirebaseFirestore.instance
          .collection('messages')
          .where('chatId', isEqualTo: chatId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (remainingMessages.docs.isNotEmpty) {
        final lastMessage = remainingMessages.docs.first;
        final lastMessageText = lastMessage['message'];
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .update({
          'lastMessage': lastMessageText,
        });
        print('Last message updated to: $lastMessageText');
      } else {
        // Если больше нет сообщений в чате, удаляем чат
        await deleteChat(chatId);
        print('Chat deleted: $chatId');
      }
    } catch (e) {
      print('Failed to delete message: $messageId, error: $e');
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      await FirebaseFirestore.instance.collection('chats').doc(chatId).delete();
      print('Chat $chatId deleted.');
    } catch (e) {
      print('Failed to delete chat: $chatId, error: $e');
    }
  }

  void editMessage(String messageId, String newText) async {
    final messageRef =
        FirebaseFirestore.instance.collection('messages').doc(messageId);
    final messageSnapshot = await messageRef.get();
    await messageRef.update({
      'message': newText,
      'edited': true,
    });
    final chatId = messageSnapshot['chatId'];
    final lastMessageQuery = await FirebaseFirestore.instance
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    if (lastMessageQuery.docs.isNotEmpty) {
      final lastMessage = lastMessageQuery.docs.first;
      final lastMessageText = lastMessage['message'];
      await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
        'lastMessage': lastMessageText,
      });
    }
  }

  void showEditMessageDialog(String messageId, String currentText) {
    final TextEditingController editController =
        TextEditingController(text: currentText);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.editMessage),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.typenewmessage),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                editMessage(messageId, editController.text);
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatId = getChatId(currentUser!.email!, widget.receiverId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  var userData = await getUserData(widget.receiverId);
                  if (userData != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileToCheck(datainfo: userData),
                      ),
                    );
                  }
                },
                child: CircleAvatar(
                  backgroundImage: receiverPhotoUrl != null
                      ? NetworkImage(receiverPhotoUrl!)
                      : null,
                  child: receiverPhotoUrl == null ? Icon(Icons.person) : null,
                ),
              ),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.receiverName,
                    style: TextStyle(fontSize: 18),
                  ),
                  ValueListenableBuilder<String?>(
                    valueListenable: statusTextNotifier,
                    builder: (context, statusText, child) {
                      return Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isOnlineNotifier.value
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            statusText ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: isOnlineNotifier.value
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .where('chatId', isEqualTo: chatId)
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    messages = snapshot.data!.docs;
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe =
                            message['senderEmail'] == currentUser!.email;
                        final hasImages = message['imageUrls'] != null &&
                            (message['imageUrls'] as List<dynamic>).isNotEmpty;
                        final imageUrls =
                            List<String>.from(message['imageUrls'] ?? []);
                        final replyToMessageId = message['replyToMessage'];
                        final isEdited = message['edited'] ?? false;
                        final isChecked = message['isChecked'];
                        final timestampField = message['timestamp'];
                        final messageId = message.id;
                        final timestamp = timestampField != null
                            ? (timestampField as Timestamp)
                            : Timestamp.now();
                        final replyToMessageText = replyToMessageId != null &&
                                messages
                                    .any((msg) => msg.id == replyToMessageId)
                            ? messages.firstWhere(
                                (msg) => msg.id == replyToMessageId)['message']
                            : null;
                        final formattedTime =
                            DateFormat('HH:mm').format(timestamp.toDate());

                        return GestureDetector(
                          onTap: () {
                            if (replyToMessageText != null) {
                              _scrollToMessage(replyToMessageId);
                            }
                          },
                          onLongPress: isMe
                              ? () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        child: Wrap(
                                          children: <Widget>[
                                            ListTile(
                                              leading: Icon(Icons.reply),
                                              title: Text(
                                                  AppLocalizations.of(context)!
                                                      .reply),
                                              onTap: () {
                                                setReplyMessage(
                                                    message.id,
                                                    message['message'] == ''
                                                        ? 'photo'
                                                        : message['message']);
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.edit),
                                              title: Text(
                                                  AppLocalizations.of(context)!
                                                      .edit),
                                              onTap: () {
                                                Navigator.pop(context);
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    final TextEditingController
                                                        _editMessageController =
                                                        TextEditingController(
                                                            text: message[
                                                                'message']);
                                                    return AlertDialog(
                                                      title: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .editMessage),
                                                      content: TextField(
                                                        controller:
                                                            _editMessageController,
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .cancel),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .save),
                                                          onPressed: () {
                                                            message.reference
                                                                .update({
                                                              'message':
                                                                  _editMessageController
                                                                      .text,
                                                              'edited': true,
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.delete),
                                              title: Text(
                                                  AppLocalizations.of(context)!
                                                      .delete),
                                              onTap: () {
                                                message.reference.delete();
                                                deleteMessage(
                                                    messageId, chatId);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              : () {
                                  setReplyMessage(
                                      message.id, message['message']);
                                },
                          child: Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 8.0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 14.0),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? Colors.lightBlueAccent
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (replyToMessageId != null) ...[
                                    FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('messages')
                                          .doc(replyToMessageId)
                                          .get(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        if (!snapshot.hasData ||
                                            !snapshot.data!.exists) {
                                          return SizedBox.shrink();
                                        }
                                        final replyMessage = snapshot.data!;
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 8.0),
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Text(
                                            replyMessage['message'] == ''
                                                ? 'photo'
                                                : replyMessage['message'],
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                  if (hasImages)
                                    Container(
                                      height: 100.0,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: imageUrls.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) {
                                                      return FullScreenImageViewer(
                                                        imageUrl:
                                                            imageUrls[index],
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Hero(
                                                tag: imageUrls[index],
                                                child: Image.network(
                                                  imageUrls[index],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  Text(
                                    message['message'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isMe ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        formattedTime,
                                        style: TextStyle(
                                          color: isMe
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                      if (isEdited)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .edited,
                                            style: TextStyle(
                                              color: isMe
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      if (isMe)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: Icon(
                                            isChecked ? null : Icons.check,
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black,
                                            size: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            ValueListenableBuilder<String?>(
              valueListenable: replyToMessageTextVariable,
              builder: (context, replyText, child) {
                if (replyText == null) {
                  return SizedBox.shrink();
                } else {
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)!.replytomessage,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(replyText),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: cancelReply,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            ValueListenableBuilder<List<XFile>>(
              valueListenable: _selectedImages,
              builder: (context, images, child) {
                return Column(
                  children: [
                    if (images.isNotEmpty)
                      Container(
                        height: 100.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.file(
                                    File(images[index].path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: Container(
                                      color: Colors.black54,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.photo),
                          onPressed: _pickImage,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type a message',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: sendMessage,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String getTimeDifferenceString(String lastOnlineString) {
    DateTime? lastOnline;

    try {
      lastOnline = DateTime.parse(lastOnlineString);
    } catch (e) {
      return lastOnlineString;
    }

    final now = DateTime.now();
    final difference = now.difference(lastOnline);
    if (difference.inMinutes < 1) {
      return '1 минуту назад';
    } else if (difference.inMinutes <= 2) {
      return '2 минуты назад';
    } else if (difference.inMinutes <= 3) {
      return '3 минуты назад';
    } else if (difference.inMinutes <= 4) {
      return '4 минуты назад';
    } else if (difference.inMinutes < 10) {
      return '5 минут назад';
    } else if (difference.inMinutes < 30) {
      return '10 минут назад';
    } else if (difference.inHours < 1) {
      return '30 минут назад';
    } else if (difference.inHours < 2) {
      return '1 час назад';
    } else if (difference.inHours > 1 && difference.inHours <= 2) {
      return '2 часа назад';
    } else {
      return DateFormat('dd.MM.yyyy HH:mm').format(lastOnline);
    }
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    String formattedDate;
    if (date.isAtSameMomentAs(today)) {
      formattedDate = AppLocalizations.of(context)!.today;
    } else if (date.isAtSameMomentAs(yesterday)) {
      formattedDate = AppLocalizations.of(context)!.yesterday;
    } else {
      formattedDate = DateFormat('dd/MM/yyyy').format(date);
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      child: Text(
        formattedDate,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class UserInfoToProfile {
  final String? photoURLPath;
  final String? aboutYourself;
  final String? name;
  final String? email;
  UserInfoToProfile({
    this.photoURLPath,
    this.aboutYourself,
    this.name,
    this.email,
  });
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              Navigator.pop(context);
            }
          },
          child: PhotoViewGallery.builder(
            itemCount: 1,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2.0,
                heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
              );
            },
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            pageController: PageController(),
            scrollPhysics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
          ),
        ),
      ),
    );
  }
}
