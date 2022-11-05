import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserManagement {
  storeNewUser(user, context, password, name) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('users').doc(firebaseUser!.uid).set({
      'email': user.email,
      'name': name,
      'uid': user.uid,
      'photoUrl': user.photoURL,
      'about_yourself': '',
      'password': password,
    }).catchError((e) {
      print(e);
    });
  }
}
