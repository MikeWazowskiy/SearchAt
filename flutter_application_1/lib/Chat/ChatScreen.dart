import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Profile/ProfileToCheck.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  ChatScreen({required this.receiverId, required this.receiverName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String? receiverPhotoUrl;
  final ValueNotifier<String?> replyToMessage = ValueNotifier<String?>(null);
  final ValueNotifier<String?> replyToMessageTextVariable =
      ValueNotifier<String?>(null);
  late ScrollController _scrollController;
  List<DocumentSnapshot> messages = [];

  @override
  void initState() {
    super.initState();
    getUserPhotoUrl(widget.receiverId);
    markMessagesAsRead();
    _scrollController = ScrollController();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    replyToMessage.dispose();
    replyToMessageTextVariable.dispose();
    super.dispose();
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

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final chatId = getChatId(currentUser!.email!, widget.receiverId);

      await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
        'chatId': chatId,
        'users': [currentUser!.email, widget.receiverId],
        'lastMessage': _messageController.text,
        'lastTimestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('messages').add({
        'chatId': chatId,
        'senderEmail': currentUser!.email,
        'receiverEmail': widget.receiverId,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'isChecked': false,
        'replyToMessage': replyToMessage.value,
        'edited' : false
      });

      _messageController.clear();
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
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .delete();

    final remainingMessages = await FirebaseFirestore.instance
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (remainingMessages.docs.isNotEmpty) {
      final lastMessage = remainingMessages.docs.first;
      final lastMessageText = lastMessage['message'];

      await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
        'lastMessage': lastMessageText,
      });
    } else {
      deleteChat(chatId);
    }
  }

  void deleteChat(String chatId) async {
    await FirebaseFirestore.instance.collection('chats').doc(chatId).delete();
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

  void clearReply() {
    replyToMessage.value = null;
    replyToMessageTextVariable.value = null;
  }

  Widget _buildMessageList(List<DocumentSnapshot> messagesList) {
    DateTime? currentDate;
    List<Widget> messageWidgets = [];
    messages = messagesList; // Save the messages list to use later
    final chatId = getChatId(currentUser!.email!, widget.receiverId);
    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      final isMe = message['senderEmail'] == currentUser?.email;
      final isChecked = message['isChecked'];
      final messageId = message.id;
      final messageText = message['message'];
      final timestampField = message['timestamp'];
      final timestamp = timestampField != null
          ? (timestampField as Timestamp)
          : Timestamp.now();

      final formattedTime = DateFormat('HH:mm').format(timestamp.toDate());
      final edited = message['edited'] ?? false;

      final replyToMessageId = message['replyToMessage'];

      final replyToMessageText = replyToMessageId != null &&
              messages.any((msg) => msg.id == replyToMessageId)
          ? messages.firstWhere((msg) => msg.id == replyToMessageId)['message']
          : null;

      final messageDate = DateTime(
        timestamp.toDate().year,
        timestamp.toDate().month,
        timestamp.toDate().day,
      );

      if (currentDate == null || !currentDate.isAtSameMomentAs(messageDate)) {
        messageWidgets.add(
          _buildDateHeader(messageDate),
        );
        currentDate = messageDate;
      }

      messageWidgets.add(
        GestureDetector(
          onLongPress: () {
            if (isMe) {
              showModalBottomSheet(
                context: context,
                builder: (context) => SafeArea(
                  child: Wrap(
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text(AppLocalizations.of(context)!.edit),
                        onTap: () {
                          Navigator.pop(context);
                          showEditMessageDialog(messageId, messageText);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete),
                        title: Text(AppLocalizations.of(context)!.delete),
                        onTap: () {
                          Navigator.pop(context);
                          deleteMessage(messageId, chatId);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          },
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              replyToMessage.value = message.id;
              replyToMessageTextVariable.value = message['message'];
            }
          },
          child: ListTile(
            title: Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: isMe ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (replyToMessageText != null)
                      GestureDetector(
                        onTap: () {
                          _scrollToMessage(replyToMessageId);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            replyToMessageText,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    Text(
                      message['message'],
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formattedTime,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        if (edited)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              'edited',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        if (isMe)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              isChecked ? null : Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return ListView(
      controller: _scrollController,
      children: messageWidgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatId = getChatId(currentUser!.email!, widget.receiverId);
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
                  UserInfoToProfile? userData =
                      await getUserData(widget.receiverId);
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
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Hero(
                    tag: 'photoTag',
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(receiverPhotoUrl ??
                          'https://firebasestorage.googleapis.com/v0/b/signinsearchat.appspot.com/o/UsersImages%2Fdefoltimegeforeveryone.jpeg?alt=media&token=3781473e-efb3-4610-9e30-c3c72559f120'),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(widget.receiverName),
            ],
          ),
        ),
        body: Column(
          children: [
            ValueListenableBuilder<String?>(
              valueListenable: replyToMessage,
              builder: (context, replyId, child) {
                if (replyId != null) {
                  return _buildReplyToMessage();
                }
                return SizedBox.shrink();
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .where('chatId', isEqualTo: chatId)
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error.'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text(AppLocalizations.of(context)!.nomessages));
                  }

                  final messages = snapshot.data!.docs;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return _buildMessageList(messages);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.typenewmessage,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyToMessage() {
    return ValueListenableBuilder<String?>(
      valueListenable: replyToMessageTextVariable,
      builder: (context, replyText, child) {
        return Container(
          color: Colors.grey[300],
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                   AppLocalizations.of(context)!.replytomessage + ' $replyText',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: clearReply,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    String formattedDate;
    if (date.isAtSameMomentAs(today)) {
      formattedDate = 'Today';
    } else if (date.isAtSameMomentAs(yesterday)) {
      formattedDate = 'Yesterday';
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
