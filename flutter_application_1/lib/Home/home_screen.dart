import 'package:flutter/material.dart';
import 'package:flutter_application_1/Chat/ChatsScreen.dart';
import 'package:flutter_application_1/Ideas/ideas_screen.dart';
import 'package:flutter_application_1/Profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _unreadMessagesCount = 0;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _getUnreadMessagesCount();
  }

  void _getUnreadMessagesCount() {
    FirebaseFirestore.instance
        .collection('messages')
        .where('receiverEmail', isEqualTo: currentUser?.email)
        .where('isChecked', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _unreadMessagesCount = snapshot.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      IdeasScreen(),
      ChatsScreen(),
      ProfileScreen(),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Color.fromARGB(255, 77, 77, 77),
        selectedItemColor: Color.fromARGB(255, 247, 96, 85),
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.chat),
                if (_unreadMessagesCount > 0)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '$_unreadMessagesCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
      body: screens[_currentIndex],
    );
  }
}
