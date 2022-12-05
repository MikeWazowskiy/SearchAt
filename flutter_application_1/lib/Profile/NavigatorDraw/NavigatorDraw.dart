import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Profile/Favorites/favorites_screen.dart';
import 'package:flutter_application_1/Profile/My%20ideas/my_ideas_screen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Log/Reg/Login/login_screen.dart';
import '../Reset password/resetpassword.dart';

class NavigationDrawWirdget extends StatefulWidget {
  const NavigationDrawWirdget(this.setLocale);
  final void Function(Locale locale) setLocale;
  @override
  _NavigationDrawWirdgetCreateState createState() =>
      _NavigationDrawWirdgetCreateState();
}

class _NavigationDrawWirdgetCreateState extends State<NavigationDrawWirdget> {
  final bool checkLanguage = true;
  sizedBoxFun(double size) {
    SizedBox sizedBox = new SizedBox(
      height: size,
    );
    return sizedBox;
  }

  final firebaseCurrentUser = FirebaseAuth.instance.currentUser;
  final paddint = EdgeInsets.symmetric(horizontal: 20);
  String? password;
  String? email;
  String? valueChoose;
  List listItem = [
    "Русский",
    "English",
  ];
  void initState() {
    super.initState();
    setState(() {
      valueChoose = "English";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: ListView(
          padding: paddint,
          children: <Widget>[
            sizedBoxFun(40),
            ListTile(
              selectedColor: Colors.white,
              leading: const Icon(
                Icons.content_paste,
                color: Color.fromARGB(255, 247, 96, 85),
              ),
              title: Text(AppLocalizations.of(context)!.myideas),
              onTap: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyIdeasScreen()));
                });
              },
            ),
            sizedBoxFun(10),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 16,
            //     ),
            //     Icon(
            //       Icons.language,
            //       color: Color.fromARGB(255, 247, 96, 85),
            //     ),
            //     SizedBox(
            //       width: 30,
            //     ),
            //     DropdownButton(
            //       style: TextStyle(fontSize: 14, color: Colors.black),
            //       value: valueChoose,
            //       onChanged: (newValue) {
            //         setState(() {
            //           valueChoose = newValue.toString();
            //           if (valueChoose == "Русский") {
            //             String language;
            //             FirebaseFirestore.instance
            //                 .collection('users')
            //                 .doc(firebaseCurrentUser!.uid)
            //                 .update({'language': 'ru'});
            //             widget
            //                 .setLocale(Locale.fromSubtags(languageCode: "ru"));
            //           } else {
            //             FirebaseFirestore.instance
            //                 .collection('users')
            //                 .doc(firebaseCurrentUser!.uid)
            //                 .update({'language': 'en'});
            //             widget
            //                 .setLocale(Locale.fromSubtags(languageCode: "en"));
            //           }
            //         });
            //       },
            //       items: listItem.map((valueItem) {
            //         return DropdownMenuItem(
            //           value: valueItem,
            //           child: Text(valueItem),
            //         );
            //       }).toList(),
            //     ),
            //   ],
            // ),
            // sizedBoxFun(10),
            ListTile(
              selectedColor: Colors.white,
              leading: const Icon(
                Icons.key,
                color: Color.fromARGB(255, 247, 96, 85),
              ),
              title: Text(
                AppLocalizations.of(context)!.resetpassword,
              ),
              onTap: () {
                NAlertDialog(
                  dialogStyle: DialogStyle(titleDivider: true),
                  title: Text(AppLocalizations.of(context)!.resetpassword),
                  content: Text(
                    (AppLocalizations.of(context)!.passworddialogmessage),
                  ),
                  actions: [
                    TextButton(
                      onPressed: (() {
                        Navigator.pop(context);
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ResetPasswordFromProfile()));
                        });
                      }),
                      child: Text(
                        (AppLocalizations.of(context)!.ok),
                      ),
                    ),
                    TextButton(
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                      child: Text(
                        (AppLocalizations.of(context)!.cancel),
                      ),
                    ),
                  ],
                ).show(context);
              },
            ),
            sizedBoxFun(20),
            Divider(
              color: Color.fromARGB(255, 77, 77, 77),
            ),
            sizedBoxFun(5),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 247, 96, 85),
              ),
              title: Text(AppLocalizations.of(context)!.signout),
              onTap: () {
                NAlertDialog(
                  dialogStyle: DialogStyle(titleDivider: true),
                  title: Text(AppLocalizations.of(context)!.signout),
                  content: Text(
                    (AppLocalizations.of(context)!.accountsignoutmessage),
                  ),
                  actions: [
                    TextButton(
                      onPressed: (() {
                        Navigator.pop(context);
                        setState(() {
                          FirebaseAuth.instance.signOut();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        });
                      }),
                      child: Text(
                        (AppLocalizations.of(context)!.ok),
                      ),
                    ),
                    TextButton(
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                      child: Text(
                        (AppLocalizations.of(context)!.cancel),
                      ),
                    ),
                  ],
                ).show(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_rounded,
                color: Color.fromARGB(255, 247, 96, 85),
              ),
              title: Text(AppLocalizations.of(context)!.deleteaccount),
              onTap: () {
                NAlertDialog(
                  dialogStyle: DialogStyle(titleDivider: true),
                  title: Text(AppLocalizations.of(context)!.deleteaccount),
                  content: Text(
                    (AppLocalizations.of(context)!.deleteaccountmessage),
                  ),
                  actions: [
                    TextButton(
                      onPressed: (() {
                        Navigator.pop(context);
                        setState(() {
                          deleteAccountAndAllIdeas();
                        });
                      }),
                      child: Text(
                        (AppLocalizations.of(context)!.ok),
                      ),
                    ),
                    TextButton(
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                      child: Text(
                        (AppLocalizations.of(context)!.cancel),
                      ),
                    ),
                  ],
                ).show(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  //Функция удаляет пользователя из базы данных и всю информацию о нем
  void deleteAccountAndAllIdeas() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseCurrentUser!.uid)
        .get()
        .then((value) {
      password = value.data()!['password'];
    }).catchError((e) {
      print(e);
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseCurrentUser!.uid)
        .get()
        .then((value) {
      email = value.data()!['email'];
    }).catchError((e) {
      print(e);
    });
    if (firebaseCurrentUser != null) {
      //Удаление пользователя
      AuthCredential credential = EmailAuthProvider.credential(
          email: email.toString(), password: password.toString());
      await firebaseCurrentUser!
          .reauthenticateWithCredential(credential)
          .then((value) {
        value.user!.delete().then((value) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login()));
        });
      });
      //Удаление фотографии из хранилища
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('UsersImages')
            .child(email! + '.jpeg');
        await ref.delete();
      } catch (e) {}
      //Удаление коллекции users
      var collectionUsers = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseCurrentUser!.uid);
      collectionUsers.delete();
    }
  }
}
