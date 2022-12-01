import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Functions/functions.dart';
import 'package:flutter_application_1/Profile/profile.dart';
import 'package:image_picker/image_picker.dart';

class BottomSheetMainClass {
  Widget bottomSheetMain(context, photoUrlPath) {
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
                onPressed: () {
                  photoUrlPath = Functions()
                      .takePhoto(ImageSource.camera, photoUrlPath, context);
                },
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
                  onPressed: () {
                    Navigator.pop(context);
                    photoUrlPath = Functions()
                        .takePhoto(ImageSource.gallery, photoUrlPath, context);
                  }),
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
                onPressed: () {
                  Navigator.pop(context);
                  Functions().removePhotoFromProfile(photoUrlPath, context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
