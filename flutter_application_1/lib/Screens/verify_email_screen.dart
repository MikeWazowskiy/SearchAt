import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/home_screen.dart';
import 'package:flutter_application_1/Util/utils.dart';
import 'package:flutter_application_1/field.dart';

class VerifyEmailScreen extends StatefulWidget {
  String email;
  VerifyEmailScreen({required this.email});
  @override
  _VerifyEmailCreateState createState() =>
      _VerifyEmailCreateState(email: email);
}

class _VerifyEmailCreateState extends State<VerifyEmailScreen> {
  bool isEmaleVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  String email;
  _VerifyEmailCreateState({required this.email});
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
    }
    setState(() {
      try {
        isEmaleVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      } catch (e) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Field()));
      }
    });
    if (isEmaleVerified) timer?.cancel();
  }

  Future sendVerificatedEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(
        () => canResendEmail = false,
      );
      await Future.delayed(Duration(seconds: 1));
      setState(
        () => canResendEmail = true,
      );
      Utils.showSnackBar('A mail has been sent to your email', true);
    } catch (e) {
      Utils.showSnackBar(e.toString(), false);
    }
  }

  @override
  Widget build(BuildContext context) => isEmaleVerified
      ? HomeScreen(
          emailFirst: email,
        )
      : Scaffold(
          body: Column(children: [
            Padding(
              padding: EdgeInsets.only(top: 200),
            ),
            Center(
              child: Text(
                'A verification email\nhas been sent to your email.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                width: 250,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 61, 210, 255),
                    onSurface: Colors.white,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: canResendEmail ? sendVerificatedEmail : null,
                  icon: Icon(
                    Icons.email,
                    size: 32,
                  ),
                  label: Text(
                    "Resent Email",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              child: TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                onPressed: () {
                  timer?.cancel();
                  FirebaseAuth.instance.signOut();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
              ),
            ),
          ]),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 61, 210, 255),
            title: Text('Verify Email'),
          ),
        );
}
