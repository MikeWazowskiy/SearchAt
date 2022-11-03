import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_application_1/Screens/create_edit_idea.dart';

import 'package:flutter_application_1/Screens/ideas_screen.dart';

import 'package:flutter_application_1/Screens/profile.dart';

class HomeScreen extends StatefulWidget {
  String emailFirst;
  HomeScreen({required this.emailFirst});
  @override
  _HomeScreenState createState() => _HomeScreenState(email: emailFirst);
}

class _HomeScreenState extends State<HomeScreen> {
  String email;
  _HomeScreenState({required this.email});
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final screens = [
      IdeasScreen(),
      ProfileScreen(emailProfile: email),
    ];
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateEditIdeaPage(),
          ),
        ),
        backgroundColor: Colors.white,
        tooltip: 'Increment',
        child: Icon(
          Icons.add,
          color: Color.fromARGB(255, 77, 77, 77),
        ),
      ),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
