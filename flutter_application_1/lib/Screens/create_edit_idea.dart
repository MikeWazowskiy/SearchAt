import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/tags.dart';

class CreateEditIdeaPage extends StatefulWidget {
  @override
  _CreateEditIdeaPageState createState() => _CreateEditIdeaPageState();
}

class _CreateEditIdeaPageState extends State<CreateEditIdeaPage> {
  var title = '';
  var description = '';
  var tags = [];
  var contacts = [];

  @override
  Widget build(BuildContext context) {
    CollectionReference ideas = FirebaseFirestore.instance.collection('ideas');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                'Title',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(
                  hintText: 'Enter your idea title...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onChanged: (value) => title = value,
              ),
              Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                maxLength: 400,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Enter your idea description...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onChanged: (value) => description = value,
              ),
              Text(
                'Tags',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 10),
              TagsField(),
              SizedBox(height: 10),
              Text(
                'Contacts',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 60),
              ElevatedButton(
                onPressed: () => ideas.add(
                  {
                    'title': title,
                    'description': description,
                    'tags': tags,
                    'contacts': contacts,
                  },
                ).then(
                  (value) => print('Idea added!'),
                ).catchError((error) => 'Failded to add the idea: $error'),
                child: Text(
                  'Publish',
                  style: TextStyle(fontSize: 25),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 0),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Color.fromARGB(255, 102, 192, 105),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
