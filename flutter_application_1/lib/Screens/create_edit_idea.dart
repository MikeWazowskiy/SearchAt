import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/edit_description_page.dart';
import 'package:flutter_application_1/Screens/home_screen.dart';
import 'package:flutter_application_1/Screens/ideas_screen.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class CreateEditIdeaPage extends StatefulWidget {
  final String description;

  CreateEditIdeaPage({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  _CreateEditIdeaPageState createState() => _CreateEditIdeaPageState();
}

class _CreateEditIdeaPageState extends State<CreateEditIdeaPage> {
  var title = '';
  var tags = [];
  var contacts = [];
  final now = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    final ideaTitleTextField = TextEditingController();
    CollectionReference ideas = FirebaseFirestore.instance.collection('ideas');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              'Idea',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: ideaTitleTextField,
              maxLength: 50,
              decoration: InputDecoration(
                  labelText: 'Idea title',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear_rounded),
                    onPressed: () => ideaTitleTextField.clear(),
                  )),
              onChanged: (value) => title = value,
            ),
            Text(
              'About',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 35),
            InkWell(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.description.isEmpty
                        ? Text(
                            'Idea description',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          )
                        : Text(
                            widget.description,
                            style: TextStyle(fontSize: 16),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                    Divider(
                      height: 45,
                      thickness: 0.9,
                      color: Colors.grey[500],
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DescriptionPage(description: widget.description),
                  ),
                );
              },
            ),
            SizedBox(height: 15),
            Text(
              'Tags',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 35),
            SizedBox(height: 10),
            Text(
              'Contacts',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                ideas
                    .add(
                      {
                        'title': title.trim(),
                        'description': widget.description.trim(),
                        'tags': tags,
                        'contacts': contacts,
                        'date': DateFormat('dd.MM.yyyy').format(now),
                      },
                    )
                    .then(
                      (value) => print('Idea added!'),
                    )
                    .catchError((error) => 'Failded to add the idea: $error');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IdeasScreen()),
                );
                showTopSnackBar(
                  context,
                  CustomSnackBar.success(
                    message: "The idea has been successfully published!",
                  ),
                );
              },
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
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
