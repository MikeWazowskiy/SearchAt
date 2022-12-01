import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

class ProfileServicePage extends StatefulWidget {
  final QuerySnapshot? data;
  final int? index;

  const ProfileServicePage({
    Key? key,
    this.data,
    this.index,
  }) : super(key: key);

  @override
  _ProfileServicePageState createState() => _ProfileServicePageState();
}

class _ProfileServicePageState extends State<ProfileServicePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  String? email;
  String? profilePhoto;
  TextEditingController aboutYourselfController = new TextEditingController();
  TextEditingController myName = new TextEditingController();
  void initState() {
    super.initState();
    email = currentUser.email;
    profilePhoto = widget.data?.docs[widget.index!]['photoUrl'] ?? '';
    myName.text = widget.data?.docs[widget.index!]['name'] ?? '';
    aboutYourselfController.text =
        widget.data?.docs[widget.index!]['about_yourself'] ?? '';
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
                  onPressed: () {},
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
                  onPressed: () {},
                ),
                SizedBox(width: 25),
                TextButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.remove_circle,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Remove",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Scaffold(
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
                            child: GestureDetector(
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
                                                profilePhoto!,
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
                                  backgroundImage: NetworkImage(profilePhoto!),
                                  radius: 90,
                                ),
                              ),
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
                      width: 280,
                      height: 50,
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: TextFormField(
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
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      child: Text(
                        '$email',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
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
                    child: Padding(
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
                          updateAboutYousel(value);
                        },
                      ),
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

  void updateName(String value) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({'name': value.trim()});
  }

  void updateAboutYousel(String value) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({'about_yourself': value.trim()});
  }
}
