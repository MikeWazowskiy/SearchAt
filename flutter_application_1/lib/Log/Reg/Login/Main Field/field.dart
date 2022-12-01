import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../../../Users/users_service.dart';
import '../../../../Util/utils.dart';
import '../../../../Main/main.dart';

class Field extends StatefulWidget {
  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<Field> {
  final formKey2 = GlobalKey<FormState>();

  late var _animatedWidget = login();

  int state = 0;
  late bool _passwordVisible;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordControllerConfirm = new TextEditingController();

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                controller: emailController,
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
                controller: passwordController,
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
                    onPressed: () => setState(() {
                      _passwordVisible = !_passwordVisible;
                      _animatedWidget = login();
                    }),
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
                controller: emailController,
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
                controller: passwordController,
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
                    onPressed: () => setState(
                      () {
                        _passwordVisible = !_passwordVisible;
                        _animatedWidget = registration();
                      },
                    ),
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
                controller: passwordControllerConfirm,
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
      emailController.dispose();
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
              controller: emailController,
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
          email: emailController.text, password: passwordController.text);
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
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) {
        UserManagement().storeNewUser(
            value.user, context, passwordController.text, emailController.text);
      }).catchError((e) {
        Utils.showSnackBar(e.toString(), false);
      });
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
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
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar('Password Reset Email Sent', true);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message, false);
      Navigator.of(context).pop();
    }
  }
}