import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../../../Users/users_service.dart';
import '../../../../Util/utils.dart';
import '../../../../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Field extends StatefulWidget {
  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<Field> with TickerProviderStateMixin {
  final formKey2 = GlobalKey<FormState>();

  late var _animatedWidget = login();
  late AnimationController _loginAnimationController;
  late AnimationController _registrAnimationController;
  late AnimationController _forgotAnimationController;
  late Animation<double> _loginAnimation;
  late Animation<double> _registrAnimation;
  late Animation<double> _forgotAnimation;
  int state = 0;
  late bool _passwordVisible;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordControllerConfirm = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _loginAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 110),
    );

    _loginAnimation =
        Tween<double>(begin: 1, end: 0.92).animate(_loginAnimationController);

    _loginAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 50), () {
          _loginAnimationController.reverse();
        });
      }
    });

    _registrAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 110),
    );

    _registrAnimation =
        Tween<double>(begin: 1, end: 0.92).animate(_registrAnimationController);

    _registrAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 50), () {
          _registrAnimationController.reverse();
        });
      }
    });

    _forgotAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 110),
    );

    _forgotAnimation =
        Tween<double>(begin: 1, end: 0.92).animate(_forgotAnimationController);

    _forgotAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 50), () {
          _forgotAnimationController.reverse();
        });
      }
    });
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
                  onTap: () {
                    setState(() {
                      _animatedWidget = login();
                      _loginAnimationController.forward(from: 0);
                    });
                  },
                  child: ScaleTransition(
                    scale: _loginAnimation,
                    child: Text(
                      (AppLocalizations.of(context)!.loginscreen),
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _animatedWidget = registration();
                      _registrAnimationController.forward(from: 0);
                    });
                  },
                  child: ScaleTransition(
                    scale: _registrAnimation,
                    child: Text(
                      (AppLocalizations.of(context)!.signupscreen),
                      style: TextStyle(fontSize: 25),
                    ),
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
            Container(
              padding: EdgeInsets.only(left: 10, top: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  (AppLocalizations.of(context)!.email),
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
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return null;
                  }
                  return EmailValidator.validate(email)
                      ? null
                      : AppLocalizations.of(context)!.emailvalidator;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.emailhinttext,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
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
                  (AppLocalizations.of(context)!.password),
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
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return null;
                  }
                  return password.length < 6
                      ? AppLocalizations.of(context)!.passwordvalidator
                      : null;
                },
                controller: passwordController,
                obscureText: !_passwordVisible,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.passwordhinttext,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
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
                  onTap: () => setState(() {
                    _animatedWidget = forgorPassword();
                    _forgotAnimationController.forward(from: 0);
                  }),
                  child: ScaleTransition(
                    scale: _forgotAnimation,
                    child: Text(
                      AppLocalizations.of(context)!.forgotpassword,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 5),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: () => signIn(),
                  child: Text(
                    AppLocalizations.of(context)!.submitforlogin,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
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
                  onTap: () {
                    setState(() {
                      _animatedWidget = login();
                      _loginAnimationController.forward(from: 0);
                    });
                  },
                  child: ScaleTransition(
                    scale: _loginAnimation,
                    child: Text(
                      (AppLocalizations.of(context)!.loginscreen),
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _animatedWidget = registration();
                      _registrAnimationController.forward(from: 0);
                    });
                  },
                  child: ScaleTransition(
                    scale: _registrAnimation,
                    child: Text(
                      (AppLocalizations.of(context)!.signupscreen),
                      style: TextStyle(fontSize: 25),
                    ),
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
              padding: EdgeInsets.only(left: 10, top: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  (AppLocalizations.of(context)!.email),
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
                  hintText: AppLocalizations.of(context)!.emailhinttext,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                controller: emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return null;
                  }
                  return EmailValidator.validate(email)
                      ? null
                      : AppLocalizations.of(context)!.emailvalidator;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  (AppLocalizations.of(context)!.password),
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
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return null;
                  }
                  return password.length < 6
                      ? AppLocalizations.of(context)!.passwordvalidator
                      : null;
                },
                controller: passwordController,
                obscureText: !_passwordVisible,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.passwordhinttext,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
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
                  AppLocalizations.of(context)!.confirmpassword,
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
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return null;
                  }
                  return password.length < 6
                      ? AppLocalizations.of(context)!.passwordvalidator
                      : null;
                },
                controller: passwordControllerConfirm,
                obscureText: !_passwordVisible,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.passwordhinttext,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 5),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: (() {
                    signUp();
                  }),
                  child: Text(
                    AppLocalizations.of(context)!.submitforsignin,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
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
      _loginAnimationController.dispose();
      _registrAnimationController.dispose();
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
                onTap: () {
                  setState(() {
                    _animatedWidget = login();
                    _loginAnimationController.forward(from: 0);
                  });
                },
                child: ScaleTransition(
                  scale: _loginAnimation,
                  child: Text(
                    (AppLocalizations.of(context)!.loginscreen),
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _animatedWidget = registration();
                    _registrAnimationController.forward(from: 0);
                  });
                },
                child: ScaleTransition(
                  scale: _registrAnimation,
                  child: Text(
                    (AppLocalizations.of(context)!.signupscreen),
                    style: TextStyle(fontSize: 25),
                  ),
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
            padding: EdgeInsets.only(left: 10, top: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                (AppLocalizations.of(context)!.email),
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
                hintText: AppLocalizations.of(context)!.emailhinttext,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              controller: emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) {
                if (email == null || email.isEmpty) {
                  // Если поле пустое, не показывать ошибку валидации
                  return null;
                }
                return EmailValidator.validate(email)
                    ? null
                    : AppLocalizations.of(context)!.emailvalidator;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 5),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                onPressed: () {
                  resetPassword();
                },
                child: Text(
                  AppLocalizations.of(context)!.submitforresetpassword,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
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
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Future<void> signIn() async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: CircularProgressIndicator(),
    ),
  );

  try {
    String email = emailController.text.trim();
    String inputPassword = passwordController.text.trim();
    String hashedInputPassword = hashPassword(inputPassword);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: hashedInputPassword,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: inputPassword,
        );

        await updatePasswordIfNeeded(inputPassword);
      } else {
        print(e);
        Utils.showSnackBar(e.message, false);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Field()));
      }
    }
  } on FirebaseAuthException catch (e) {
    print(e);
    Utils.showSnackBar(e.message, false);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Field()));
  } finally {
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

String hashPassword(String password) {
  var bytes = utf8.encode(password); // Конвертируем строку в байты
  var digest = sha256.convert(bytes); // Применяем алгоритм SHA-256
  return digest.toString(); // Возвращаем хеш пароля в виде строки
}

bool isHashed(String password) {
  // Проверяем, является ли строка хэшированным значением
  // SHA-256 хэш обычно имеет длину 64 символа
  final regex = RegExp(r'^[a-fA-F0-9]{64}$');
  return regex.hasMatch(password);
}

Future<void> updatePasswordIfNeeded(String newPassword) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String hashedPassword =
        isHashed(newPassword) ? newPassword : hashPassword(newPassword);

    try {
      await user.updatePassword(hashedPassword);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'password': hashedPassword,
      });
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
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
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      if (signInMethods.isEmpty) {
        // Аккаунт с данным email не существует, можно создать новый
        String hashedPassword = hashPassword(password);

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: hashedPassword,
        );

        // Сохраняем информацию о новом пользователе
        UserManagement().storeNewUser(
          FirebaseAuth.instance.currentUser,
          context,
          hashedPassword,
          email,
        );
      } else {
        Utils.showSnackBar('Аккаунт с данным email уже существует', false);
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message.toString(), false);
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
      Utils.showSnackBar(
          AppLocalizations.of(context)!.passwordresentemailsendmessage, true);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message, false);
      Navigator.of(context).pop();
    }
  }
}
