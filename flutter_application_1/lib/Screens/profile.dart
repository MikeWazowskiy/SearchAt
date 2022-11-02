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
            SizedBox(
              height: 40,
            ),
            Container(
              height: 300,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 230, 230, 230),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 90,
                      child: Text(
                        'NG',
                        style: TextStyle(fontSize: 25, color: Colors.white),
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
            SizedBox(
              height: 20,
            ),
            Container(
              height: 200,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 230, 230, 230),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
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
