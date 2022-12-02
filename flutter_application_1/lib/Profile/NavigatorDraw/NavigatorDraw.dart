import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Profile/Favorites/favorites_screen.dart';
import 'package:flutter_application_1/Profile/My%20ideas/my_ideas_screen.dart';
import 'package:ndialog/ndialog.dart';

import '../../Log/Reg/Login/login_screen.dart';
import '../Reset password/resetpassword.dart';

class NavigationDrawWirdget extends StatefulWidget {
  @override
  _NavigationDrawWirdgetCreateState createState() =>
      _NavigationDrawWirdgetCreateState();
}

class _NavigationDrawWirdgetCreateState extends State<NavigationDrawWirdget> {
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
                Icons.favorite_border,
                color: Color.fromARGB(255, 247, 96, 85),
              ),
              title: Text('Favourites'),
              onTap: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FavoritesScreen()));
                });
              },
            ),
            sizedBoxFun(10),
            ListTile(
              selectedColor: Colors.white,
              leading: const Icon(
                Icons.content_paste,
                color: Color.fromARGB(255, 247, 96, 85),
              ),
              title: Text('My Ideas'),
              onTap: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyIdeasScreen()));
                });
              },
            ),
            sizedBoxFun(10),
            ListTile(
              selectedColor: Colors.white,
              leading: const Icon(
                Icons.key,
                color: Color.fromARGB(255, 247, 96, 85),
              ),
              title: Text('Reset password'),
              onTap: () {
                NAlertDialog(
                  dialogStyle: DialogStyle(titleDivider: true),
                  title: Text('Reset password'),
                  content: Text(
                    'Are you sure you want to reset your password?',
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
                        'OK',
                      ),
                    ),
                    TextButton(
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                      child: Text(
                        'Cancel',
                      ),
                    ),
                  ],
                ).show(context);
              },
            ),
            sizedBoxFun(15),
            Divider(
              color: Color.fromARGB(255, 77, 77, 77),
            ),
            sizedBoxFun(5),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 247, 96, 85),
              ),
              title: Text('Sign Out'),
              onTap: () {
                NAlertDialog(
                  dialogStyle: DialogStyle(titleDivider: true),
                  title: Text('Sign Out'),
                  content: Text(
                    'Are you sure you want to sign out from your account?',
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
                        'OK',
                      ),
                    ),
                    TextButton(
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                      child: Text(
                        'Cancel',
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
              title: Text('Delete account'),
              onTap: () {
                NAlertDialog(
                  dialogStyle: DialogStyle(titleDivider: true),
                  title: Text('Delete'),
                  content: Text(
                    'Are you sure you want to delete your account?',
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
                        'OK',
                      ),
                    ),
                    TextButton(
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                      child: Text(
                        'Cancel',
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
