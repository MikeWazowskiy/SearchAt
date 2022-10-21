import 'package:flutter/material.dart';

import 'package:flutter_application_1/main.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text) {
    if (text == null) return;
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );
    messengerKey.currentState!
      ..removeCurrentMaterialBanner()
      ..showSnackBar(snackBar);
  }
}
