import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/create_edit_idea.dart';
import 'package:flutter_application_1/idea_card.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenCreateState createState() => _FavoritesScreenCreateState();
}

class _FavoritesScreenCreateState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[50],
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
