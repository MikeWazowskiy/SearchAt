import 'package:flutter/material.dart';
import 'package:flutter_application_1/Chat/ChatScreen.dart';
import 'package:flutter_application_1/Users/users_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IdeaCard extends StatelessWidget {
  final data;
  final int index;

  IdeaCard({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  Future<void> navigateToChat(BuildContext context, String email) async {
    UserManagement userManagement = UserManagement();
    String? userName = await userManagement.getUserNameByEmail(email);
    if (userName != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            receiverId: email,
            receiverName: userName,
          ),
        ),
      );
    } else {
      print("User name not found for email: $email");
    }
  }

  @override
  Widget build(BuildContext context) {
    List tags = data.docs[index]['tags'];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${data.docs[index]['title']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.by}: ${data.docs[index]['user_email']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${data.docs[index]['description']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      spacing: 8,
                      children: tags
                          .map((element) => Chip(
                                label: Text(
                                  element,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Color.fromARGB(255, 247, 96, 85),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.date}: ${data.docs[index]['date']}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.chat),
                      onPressed: () {
                        navigateToChat(context, data.docs[index]['user_email']);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
