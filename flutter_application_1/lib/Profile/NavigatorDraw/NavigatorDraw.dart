import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Profile/My%20ideas/my_ideas_screen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Log/Reg/Login/login_screen.dart';
import '../Reset password/resetpassword.dart';

class NavigationDrawWirdget extends StatefulWidget {
  @override
  _NavigationDrawWirdgetCreateState createState() =>
      _NavigationDrawWirdgetCreateState();
}

class _NavigationDrawWirdgetCreateState extends State<NavigationDrawWirdget> {
  final firebaseCurrentUser = FirebaseAuth.instance.currentUser;
  final paddint = EdgeInsets.symmetric(horizontal: 10);
  String? password;
  String? email;
  String? valueChoose;
  String? lastPassword;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      clipBehavior: Clip.none,
      child: Material(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
        ),
        child: ListView(
          padding: paddint,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 35),
              child: ListTile(
                selectedColor: Colors.white,
                leading: const Icon(
                  Icons.content_paste,
                  color: Color.fromARGB(255, 247, 96, 85),
                ),
                title: Text(AppLocalizations.of(context)!.myideas),
                onTap: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyIdeasScreen()));
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: ListTile(
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
                    dialogStyle: DialogStyle(
                        titleDivider: true, backgroundColor: Colors.white),
                    title: Text(AppLocalizations.of(context)!.resetpassword),
                    content: Text(
                      (AppLocalizations.of(context)!.passworddialogmessage),
                    ),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
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
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
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
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 5, right: 17, left: 17),
              child: Divider(
                thickness: 1.1,
                color: Color.fromARGB(255, 77, 77, 77),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 247, 96, 85),
              ),
              title: Text(AppLocalizations.of(context)!.signout),
              onTap: () {
                NAlertDialog(
                  dialogStyle: DialogStyle(
                      titleDivider: true, backgroundColor: Colors.white),
                  title: Text(AppLocalizations.of(context)!.signout),
                  content: Text(
                    (AppLocalizations.of(context)!.accountsignoutmessage),
                  ),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
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
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
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
                  dialogStyle: DialogStyle(
                      titleDivider: true, backgroundColor: Colors.white),
                  title: Text(AppLocalizations.of(context)!.deleteaccount),
                  content: Text(
                    (AppLocalizations.of(context)!.deleteaccountmessage),
                  ),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
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
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
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
      lastPassword = value.data()!['password'];
    }).catchError((e) {
      print(e);
    });
    email = firebaseCurrentUser!.email;
    final cred = EmailAuthProvider.credential(
        email: email.toString(), password: lastPassword.toString());
    firebaseCurrentUser!.reauthenticateWithCredential(cred).then((value) async {
      final ideasRef = FirebaseFirestore.instance.collection('ideas');
      ideasRef
          .where("user_email", isEqualTo: email)
          .get()
          .then((querySnapshot) {
        for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
          documentSnapshot.reference.delete();
        }
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseCurrentUser!.uid)
          .get()
          .then((value) {
        password = value.data()!['password'];
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
    }).catchError((err) {
      print(err.toString());
    });
    {}
    ;
  }
}
