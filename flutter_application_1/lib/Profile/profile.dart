import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Favorites/favorites_screen.dart';
import 'package:flutter_application_1/Log/Reg/Login/login_screen.dart';
import 'package:flutter_application_1/Profile/Bottom%20Sheet/bottomsheet.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:flutter_application_1/Profile/Bottom Sheet/bottomsheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_application_1/My%20ideas/my_ideas_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenCreateState createState() => _ProfileScreenCreateState();
}

class _ProfileScreenCreateState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  TextEditingController aboutYourselfController = new TextEditingController();
  String? email;
  String? photoURLPath;
  File? _imageFile;
  TextEditingController myName = new TextEditingController();
  final _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BottomSheetMainClass().bottomSheetMain(context, photoURLPath);
    return Scaffold(
      drawer: NavigationDrawWirdget(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 77, 77, 77),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: 17, left: 15, right: 15, bottom: 20),
              child: Container(
                height: 320,
                width: 380,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            child: FutureBuilder(
                              future: _pickImage(),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done)
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) {
                                          return FullScreenWidget(
                                            child: Center(
                                              child: Hero(
                                                tag: "smallImage",
                                                child: ClipRRect(
                                                  child: Image.network(
                                                    photoURLPath!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          NetworkImage(photoURLPath!),
                                      radius: 90,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 145, right: 115),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: () {
                                    showBottomSheet(
                                      context: context,
                                      builder: ((builder) =>
                                          BottomSheetMainClass()
                                              .bottomSheetMain(
                                                  context, photoURLPath)),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 280,
                      height: 50,
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: FutureBuilder(
                              future: _name(),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) return Text('');
                                return TextFormField(
                                  onChanged: (value) {
                                    try {
                                      updateName(value);
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  controller: myName,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      child: FutureBuilder(
                        future: _email(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) return Text('');
                          return Text(
                            '$email',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 235,
              width: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 15),
                      child: Text(
                        'About yourself:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      height: 10,
                      color: Color.fromARGB(255, 77, 77, 77),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                    child: FutureBuilder(
                      future: _aboutYourself(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Text('');
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 14,
                            right: 10,
                          ),
                          child: TextFormField(
                            controller: aboutYourselfController,
                            maxLength: 300,
                            minLines: 3,
                            maxLines: 5,
                            textAlign: TextAlign.justify,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(6),
                              hintText: aboutYourselfController.text == ""
                                  ? 'You have nothing about youself :('
                                  : null,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              updateAboutYouselfAndName(value);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  //Удаление фотографии пользователя
  void removePhotoFromProfile() async {
    setState(() {
      photoURLPath =
          'https://firebasestorage.googleapis.com/v0/b/signinsearchat.appspot.com/o/UsersImages%2Fdefoltimegeforeveryone.jpeg?alt=media&token=3781473e-efb3-4610-9e30-c3c72559f120';
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({'photoUrl': photoURLPath});
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        message: "Photo was successfully removed!",
      ),
    );
  }

  //Обновление имени пользователя в реальном времени
  void updateName(String value) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({'name': value.trim()});
  }

  //Обновление информации о себе в реальном времени
  void updateAboutYouselfAndName(String value) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({'about_yourself': value.trim()});
  }

  void takePhoto(ImageSource source) async {
    try {
      Navigator.pop(context);
      final image = await _picker.pickImage(
          source: source, imageQuality: 100, maxHeight: 512, maxWidth: 512);
      if (image != null) {
        _imageFile = File(image.path);
      }
      if (_imageFile == null)
        return;
      else {
        final ref = FirebaseStorage.instance
            .ref()
            .child('UsersImages')
            .child(email! + '.jpeg');
        await ref.putFile(_imageFile!);
        _imageFile = null;
        photoURLPath = await ref.getDownloadURL();
        setState(() {
          photoURLPath = photoURLPath;
        });
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: "Photo was published!",
          ),
        );
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'photoUrl': photoURLPath});
      }
    } catch (e) {}
  }

  //Вывод информации о себе из бд
  _aboutYourself() async {
    if (currentUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get()
          .then((value) {
        aboutYourselfController.text = value.data()!['about_yourself'];
      }).catchError((e) {
        print(e);
      });
  }

  //Вывод фотографии из бд
  _pickImage() async {
    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get()
          .then((value) async {
        photoURLPath = value.data()!['photoUrl'];
        if (photoURLPath == null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('UsersImages')
              .child('defoltimegeforeveryone.jpeg');
          photoURLPath = await ref.getDownloadURL();
        }
      }).catchError((e) {
        print(e);
      });
    }
  }

  //Вывод почты из бд
  _email() async {
    if (currentUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get()
          .then((value) {
        email = value.data()!['email'];
      }).catchError((e) {
        print(e);
      });
  }

  //Вывод имени пользователя из бд
  _name() async {
    if (currentUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get()
          .then((value) {
        myName.text = value.data()!['name'];
      }).catchError((e) {
        print(e);
      });
  }
}

// Выдвигающаяся панель слева
class NavigationDrawWirdget extends StatefulWidget {
  @override
  _NavigationDrawWirdgetCreateState createState() =>
      _NavigationDrawWirdgetCreateState();
}

class _NavigationDrawWirdgetCreateState extends State<NavigationDrawWirdget> {
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
            SizedBox(
              height: 40,
            ),
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
            SizedBox(
              height: 10,
            ),
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
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Color.fromARGB(255, 77, 77, 77),
            ),
            SizedBox(
              height: 3,
            ),
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
