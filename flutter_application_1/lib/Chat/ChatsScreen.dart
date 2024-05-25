import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Chat/ChatScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatsScreen extends StatelessWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<UserInfo?> getUserInfo(String userEmail) async {
    try {
      var userDocs = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userDocs.docs.isNotEmpty) {
        var userData = userDocs.docs[0].data();
        return UserInfo(
          name: userData['name'],
          photoUrl: userData['photoUrl'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user info: $e');
      return null;
    }
  }

  Future<int> getUnreadMessagesCount(String chatId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .where('receiverEmail', isEqualTo: currentUser?.email)
        .where('isChecked', isEqualTo: false)
        .get();

    return snapshot.docs.length;
  }

  Future<void> deleteChat(String chatId) async {
    try {
      // Удалить все сообщения чата
      await FirebaseFirestore.instance
          .collection('messages')
          .where('chatId', isEqualTo: chatId)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // Удалить чат
      await FirebaseFirestore.instance.collection('chats').doc(chatId).delete();
    } catch (e) {
      print('Error deleting chat: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.chats),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('users', arrayContains: currentUser?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.nochats));
          }

          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final receiverEmail = chat['users']
                  .firstWhere((email) => email != currentUser?.email);
              final chatId = chat.id; // Получить ID чата

              return FutureBuilder<UserInfo?>(
                future: getUserInfo(receiverEmail),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text(receiverEmail),
                      subtitle: Text(chat['lastMessage']),
                      leading: CircularProgressIndicator(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              receiverId: receiverEmail,
                              receiverName: receiverEmail,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (snapshot.hasError) {
                    return ListTile(
                      title: Text(receiverEmail),
                      subtitle: Text(chat['lastMessage']),
                      leading: Icon(Icons.error),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              receiverId: receiverEmail,
                              receiverName: receiverEmail,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  final userInfo = snapshot.data;

                  return Dismissible(
                    key: Key(chatId), // Уникальный ключ для элемента списка
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      // Удалить чат при смахивании
                      deleteChat(chatId);
                    },
                    confirmDismiss: (direction) async {
                      // Запросить подтверждение перед удалением чата
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                Text(AppLocalizations.of(context)!.deletechat),
                            content: Text(AppLocalizations.of(context)!
                                .confirmdeletechat),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child:
                                    Text(AppLocalizations.of(context)!.cancel),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text(
                                    AppLocalizations.of(context)!.delete,
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: ListTile(
                      title: Text(receiverEmail),
                      subtitle: Text(chat['lastMessage']),
                      leading: CircleAvatar(
                        backgroundImage: userInfo!.photoUrl != null
                            ? NetworkImage(userInfo.photoUrl!)
                            : NetworkImage(
                                'https://firebasestorage.googleapis.com/v0/b/signinsearchat.appspot.com/o/UsersImages%2Fdefoltimegeforeveryone.jpeg?alt=media&token=3781473e-efb3-4610-9e30-c3c72559f120'), // Заглушка, если URL фото не найден
                      ),
                      trailing: FutureBuilder<int>(
                        future: getUnreadMessagesCount(chatId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text('Error');
                          }
                          final unreadMessagesCount = snapshot.data!;
                          return Container(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                              color: unreadMessagesCount > 0
                                  ? Colors.red
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              '$unreadMessagesCount',
                              style: TextStyle(color: Colors.white, fontSize: 14),
        
                            ),
                          );
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              receiverId: receiverEmail,
                              receiverName: userInfo.name!,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class UserInfo {
  final String? name;
  final String? photoUrl;

  UserInfo({this.name, this.photoUrl});
}
