import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Profile/profile.dart';
import 'package:flutter_application_1/Util/utils.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ResetPasswordFromProfile extends StatefulWidget {
  @override
  ResetPasswordFromProfileState createState() =>
      ResetPasswordFromProfileState();
}

class ResetPasswordFromProfileState extends State<ResetPasswordFromProfile> {
  late bool _passwordVisible;
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordConfirmController = new TextEditingController();
  String? lastPassword;
  String? email;
  final currentUser = FirebaseAuth.instance.currentUser;
  sizedBoxFun(double size) {
    SizedBox sizedBox = new SizedBox(
      height: size,
    );
    return sizedBox;
  }

  void initState() {
    _passwordVisible = false;
    setState(() {
      email = currentUser!.email.toString();
      if (currentUser != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get()
            .then((value) async {
          lastPassword = await value.data()!['password'];
        }).catchError((e) {
          print(e);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Reset password',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[50],
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 365,
          width: 380,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              sizedBoxFun(40),
              Text(
                'Type new password',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              sizedBoxFun(30),
              Container(
                height: 90,
                width: 300,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Enter min. 6 characters'
                      : null,
                  controller: passwordController,
                  obscureText: !_passwordVisible,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () => setState(() {
                        _passwordVisible = !_passwordVisible;
                      }),
                    ),
                  ),
                ),
              ),
              Container(
                height: 90,
                width: 300,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Enter min. 6 characters'
                      : null,
                  controller: passwordConfirmController,
                  obscureText: !_passwordVisible,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Confirm your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (() {
                  checkPasswords();
                }),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkPasswords() async {
    if (passwordConfirmController.text == passwordController.text) {
      if (lastPassword != passwordController.text) {
        if (passwordController.text.length >= 6) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .update({'password': passwordController.text.trim()});
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              message: "Password was changed",
            ),
          );
          setState(() {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfileScreen()));
          });
        } else {
          Utils.showSnackBar('enter a longer password', false);
        }
      } else {
        Utils.showSnackBar('you cannot enter the old password', false);
      }
    } else {
      Utils.showSnackBar('enter the same password', false);
    }
  }
}
