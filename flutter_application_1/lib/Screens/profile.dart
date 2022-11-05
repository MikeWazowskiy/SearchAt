import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenCreateState createState() => _ProfileScreenCreateState();
}

class _ProfileScreenCreateState extends State<ProfileScreen> {
  TextEditingController aboutYourselfController = new TextEditingController();
  String? aboutYourself;
  String? photoURLPath;
  XFile? _imageFile;
  String? myName;
  final _picker = ImagePicker();
  @override
  _aboutYourself() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((value) {
        aboutYourself = value.data()!['about_yourself'];
        print(aboutYourself);
      }).catchError((e) {
        print(e);
      });
  }

  _pickImage() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((value) {
        photoURLPath = value.data()!['photoURL'];
        print(photoURLPath);
      }).catchError((e) {
        print(e);
      });
  }

  _name() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((value) {
        myName = value.data()!['name'];
        print(myName);
      }).catchError((e) {
        print(e);
      });
  }

  @override
  Widget build(BuildContext context) {
    Widget bottomSheet() {
      return Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            Text(
              'Choose Profile photo',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Camera",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                ),
                SizedBox(width: 35),
                TextButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Gallery",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
      drawer: NavigationDrawWirdget(),
      appBar: AppBar(
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
                height: 300,
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
                                return photoURLPath != null
                                    ? Align(
                                        alignment: Alignment.topCenter,
                                        child: CircleAvatar(
                                          backgroundImage: FileImage(
                                            File(photoURLPath!),
                                          ),
                                          radius: 90,
                                        ))
                                    : Align(
                                        alignment: Alignment.topCenter,
                                        child: CircleAvatar(
                                          backgroundColor: Color.fromARGB(
                                              255, 228, 228, 228),
                                          child: Text(
                                            'No User Photo',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                          radius: 90,
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
                                      builder: ((builder) => bottomSheet()),
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
                      child: FutureBuilder(
                        future: _name(),
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) return Text('');
                          return Text(
                            '$myName',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          );
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'SearchAt user',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
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
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
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
                      color: Color.fromARGB(255, 77, 77, 77),
                    ),
                  ),
                  Container(
                    child: FutureBuilder(
                      future: _aboutYourself(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Text('');
                        return Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            maxLength: 300,
                            minLines: 3,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: aboutYourself == ""
                                  ? 'You have nothing about youself :('
                                  : '',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
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
            Container(
              width: 220,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  updateAboutYouselfAndName();
                },
                child: const Text(
                  'Save Changed',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateAboutYouselfAndName() async {
    final firebaseCurrentUser = await FirebaseAuth.instance.currentUser;
    aboutYourself = aboutYourselfController.text;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseCurrentUser!.uid)
        .update({'about_yourself': aboutYourself});
  }

  void takePhoto(ImageSource source) async {
    try {
      var image = await _picker.pickImage(source: source);
      setState(() {
        _imageFile = image;
        if (_imageFile == null)
          return;
        else {
          savePhoto(_imageFile?.path);
          Navigator.pop(context);
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: "Photo was published, restart Page :)",
            ),
          );
          final firebaseCurrentUser = FirebaseAuth.instance.currentUser;
          FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseCurrentUser!.uid)
              .update({'photoUrl': _imageFile!.path});
        }
      });
    } on PlatformException catch (e) {
      Navigator.of(context).pop();
    }
  }

  void savePhoto(path) async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    if (path == null)
      return;
    else {
      saveimage.setString("imagepath", path);
    }
  }
}

class NavigationDrawWirdget extends StatelessWidget {
  final paddint = EdgeInsets.symmetric(horizontal: 20);
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
              onTap: () {},
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
              onTap: () {},
            ),
            SizedBox(
              height: 20,
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
              onTap: () => FirebaseAuth.instance.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
