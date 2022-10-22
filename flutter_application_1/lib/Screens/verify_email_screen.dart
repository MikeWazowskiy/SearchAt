import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_application_1/Screens/home_screen.dart';

import 'package:flutter_application_1/Screens/signin_screen.dart';

import 'package:flutter_application_1/Util/utils.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  _VerifyEmailCreateState createState() => _VerifyEmailCreateState();
}

class _VerifyEmailCreateState extends State<VerifyEmailScreen> {
  bool isEmaleVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmaleVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmaleVerified) {
      sendVerificatedEmail();
      timer = Timer.periodic(
        Duration(seconds: 1),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
    } catch (e) {
      Utils.showSnackBar(e.toString(), false);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInScreen()));
    }
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      try {
        isEmaleVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      } catch (e) {
        Utils.showSnackBar(e.toString(), false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
      }
    });
    if (isEmaleVerified) timer?.cancel();
  }

  Future sendVerificatedEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      Utils.showSnackBar(e.toString(), false);
    }
  }

  @override
  Widget build(BuildContext context) => isEmaleVerified
      ? HomeScreen()
      : Scaffold(
          appBar: AppBar(
            title: Text('Verify Email'),
          ),
        );
}
