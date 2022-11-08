import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/create_edit_idea.dart';
import 'package:flutter_application_1/idea_card.dart';

class MyIdeasScreen extends StatefulWidget {
  @override
  _MyIdeasScreenCreateState createState() => _MyIdeasScreenCreateState();
}

class _MyIdeasScreenCreateState extends State<MyIdeasScreen> {
  final currentUsser = FirebaseAuth.instance.currentUser;
  String? email;
  _email() async {
    if (currentUsser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUsser!.email)
          .get()
          .then((value) {
        email = value.data()!['email'];
      }).catchError((e) {
        print(e);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('ideas')
            .where('email', isEqualTo: email)
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.size,
            itemBuilder: ((context, index) {
              return IdeaCard(data: data, index: index);
            }),
          );
        }),
      ),
    );
  }
}
