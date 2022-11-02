import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../Colors/colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenCreateState createState() => _ProfileScreenCreateState();
}

class _ProfileScreenCreateState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 207, 207, 207),
                        radius: 90,
                        child: Text(
                          'NG',
                          style: TextStyle(
                              fontSize: 25,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Nikita Coolest',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 14,
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
                    offset: Offset(0, 3), // changes position of shadow
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
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 2),
                    child: TextFormField(
                      maxLength: 300,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Type Anything about yourself',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 240, 240, 240),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 240, 240, 240),
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
              onTap: () => FirebaseAuth.instance.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
