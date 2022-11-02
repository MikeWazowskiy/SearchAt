import 'package:flutter/material.dart';

class CreateEditIdeaPage extends StatefulWidget {
  @override
  _CreateEditIdeaPageState createState() => _CreateEditIdeaPageState();
}

class _CreateEditIdeaPageState extends State<CreateEditIdeaPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Title',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
            TextFormField(
              maxLength: 50,
              decoration: InputDecoration(
                hintText: 'Enter your idea title...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            Text(
              'Description',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
            TextFormField(
              maxLength: 400,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Enter your idea description...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            Text(
              'Tags',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
