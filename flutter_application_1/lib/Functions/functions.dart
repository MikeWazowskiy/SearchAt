import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Functions {
  final currentUser = FirebaseAuth.instance.currentUser!;
  File? _imageFile;
  takePhoto(ImageSource source, String photoURL) async {
    try {
      final _picker = ImagePicker();
      final image = await _picker.pickImage(
          source: source, imageQuality: 100, maxHeight: 512, maxWidth: 512);
      if (image != null) {
        _imageFile = File(image.path);
      }
      if (_imageFile == null)
        return null;
      else {
        final ref = FirebaseStorage.instance
            .ref()
            .child('UsersImages')
            .child(currentUser.email! + '.jpeg');
        await ref.putFile(_imageFile!);
        photoURL = await ref.getDownloadURL();
        final firebaseCurrentUser = FirebaseAuth.instance.currentUser;
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseCurrentUser!.uid)
            .update({'photoUrl': photoURL});
        return photoURL;
      }
    } catch (e) {}
  }
}
