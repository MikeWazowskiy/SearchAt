import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/create_edit_idea.dart';
import 'package:flutter_application_1/idea_card.dart';

class IdeasScreen extends StatefulWidget {
  @override
  _IdeasScreenCreateState createState() => _IdeasScreenCreateState();
}

class _IdeasScreenCreateState extends State<IdeasScreen> {
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
        backgroundColor: Colors.white,
        title: TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Search...'),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 247, 96, 85),
        child: Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEditIdeaPage(
                editing: false,
              ),
            ),
          );
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ideas')
            .where('user_email', isNotEqualTo: currentUsser!.email)
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
              return GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateEditIdeaPage(
                        data: data,
                        index: index,
                        editing: true,
                      ),
                    ),
                  );
                },
                child: IdeaCard(data: data, index: index),
              );
            }),
          );
        }),
      ),
    );
  }
}
