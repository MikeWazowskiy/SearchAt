import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget bottomSheetMain(context) {
  return Container(
    height: 100,
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    child: Column(
      children: [
        Text(
          'Choose Profile photo',
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Row(
                children: [
                  Icon(
                    Icons.camera,
                    color: Colors.black,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Camera",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              onPressed: () {},
            ),
            SizedBox(width: 35),
            TextButton(
                child: Row(
                  children: [
                    Icon(
                      Icons.image,
                      color: Colors.black,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Gallery",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                onPressed: () {}),
            SizedBox(width: 25),
            TextButton(
              child: Row(
                children: [
                  Icon(
                    Icons.remove_circle,
                    color: Color.fromARGB(255, 255, 0, 0),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Remove",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    ),
  );
}
