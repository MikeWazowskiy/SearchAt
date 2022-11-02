import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'Util/utils.dart';
import 'main.dart';

class Field extends StatefulWidget {
  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<Field> {
  final formKey2 = GlobalKey<FormState>();

  late Widget _animatedWidget = login();

  int state = 0;
  late bool _passwordVisible;
  TextEditingController emailControllerForSignIn = new TextEditingController();
  TextEditingController passwordControllerForSignIn =
      new TextEditingController();

  TextEditingController emailControllerForSignUp = new TextEditingController();
  TextEditingController passwordControllerForSignUp =
      new TextEditingController();
  TextEditingController passwordControllerConfirmForSignUp =
      new TextEditingController();

  TextEditingController emailControllerForForgotPassword =
      new TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.bounceIn,
      child: _animatedWidget,
    );
  }

  Widget login() {
    return Container(
      key: Key('first'),
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 25),
                  ),
                  onTap: () => setState(
                    () => _animatedWidget = login(),
                  ),
                ),
                InkWell(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 25),
                  ),
                  onTap: () => setState(() {
                    _animatedWidget = registration();
                  }),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            Divider(
              color: Colors.black,
              height: 30,
              indent: 10,
              endIndent: 10,
              thickness: 1,
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                controller: emailControllerForSignIn,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Enter min. 6 characters'
                    : null,
                controller: passwordControllerForSignIn,
                obscureText: !_passwordVisible,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: Text(
                    'Forgot your password?',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () => setState(() {
                    _animatedWidget = forgorPassword();
                  }),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () => signIn(),
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
            ),
          ],
        ),
      ),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      margin: EdgeInsets.only(right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }

  Widget registration() {
    return Form(
      key: formKey2,
      child: Container(
        key: Key('second'),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => setState(
                    () => _animatedWidget = login(),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                InkWell(
                  onTap: () => setState(
                    () => _animatedWidget = registration(),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            Divider(
              color: Colors.black,
              height: 30,
              indent: 10,
              endIndent: 10,
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                controller: emailControllerForSignUp,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Enter min. 6 characters'
                    : null,
                controller: passwordControllerForSignUp,
                obscureText: !_passwordVisible,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Confirm password',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Enter min. 6 characters'
                    : null,
                controller: passwordControllerConfirmForSignUp,
                obscureText: !_passwordVisible,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: 'Enter your password again',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: (() {
                  signUp();
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
            ),
          ],
        ),
        padding: EdgeInsets.all(15),
        width: double.infinity,
        margin: EdgeInsets.only(right: 20, left: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }

  Widget forgorPassword() {
    @override
    void dispose() {
      emailControllerForForgotPassword.dispose();
      super.dispose();
    }

    return Container(
      key: Key('third'),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => setState(
                  () => _animatedWidget = login(),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              InkWell(
                onTap: () => setState(
                  () => _animatedWidget = registration(),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          Divider(
            color: Colors.black,
            height: 30,
            indent: 10,
            endIndent: 10,
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, top: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter your email address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              controller: emailControllerForForgotPassword,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email'
                      : null,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () {
                resetPassword();
              },
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
          ),
        ],
      ),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      margin: EdgeInsets.only(right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailControllerForSignIn.text,
          password: passwordControllerForSignIn.text);
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message, false);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Field()));
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    return;
  }

  Future signUp() async {
    final isValid = formKey2.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailControllerForSignUp.text.trim(),
        password: passwordControllerForSignUp.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message, false);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    return;
  }

  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailControllerForForgotPassword.text.trim());
      Utils.showSnackBar('Password Reset Email Sent', true);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message, false);
      Navigator.of(context).pop();
    }
  }
}
