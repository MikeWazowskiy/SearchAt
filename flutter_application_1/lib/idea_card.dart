import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IdeaCard extends StatelessWidget {
  final data;
  final int index;

  IdeaCard({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              '${data.docs[index]['title']}',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            SizedBox(
              height: 15,
            ),
            Text('Имя пользователя'),
            SizedBox(
              height: 20,
            ),
            Text(
              '${data.docs[index]['description']}',
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '${data.docs[index]['date']}',
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
