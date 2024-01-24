import 'dart:io';
import 'package:flutter_application_1/Users/users_service.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Profile/NavigatorDraw/NavigatorDraw.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

bool _isLoading = false;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenCreateState createState() => _ProfileScreenCreateState();
}

class _ProfileScreenCreateState extends State<ProfileScreen> {
  final nameFocusNode = FocusNode();
  final aboutYourselfFocusNode = FocusNode();
  final currentUser = FirebaseAuth.instance.currentUser!;
  TextEditingController aboutYourselfController = new TextEditingController();
  File? _imageFile;
  TextEditingController myName = new TextEditingController();
  final _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    Widget bottomSheet() {
      return Container(
        height: 137,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Text(
              (AppLocalizations.of(context)!.chooseprofilephoto),
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
                        (AppLocalizations.of(context)!.camera),
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                ),
                TextButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5),
                      Text(
                        (AppLocalizations.of(context)!.gallery),
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                ),
                TextButton(
                  child: Row(
                    children: [
                      Icon(
                        Icons.remove_circle,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                      SizedBox(width: 5),
                      Text(
                        (AppLocalizations.of(context)!.removephoto),
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  onPressed: () {
                    removePhotoFromProfile();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        nameFocusNode.unfocus();
        aboutYourselfFocusNode.unfocus();
      },
      child: Scaffold(
        drawer: NavigationDrawWirdget(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.profile,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 77, 77, 77),
          ),
          backgroundColor: Colors.white,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 17, left: 15, right: 15, bottom: 20),
                      child: Container(
                        height: 320,
                        width: MediaQuery.of(context).size.width,
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
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    child: FutureBuilder(
                                      future: _pickImage(),
                                      builder: ((context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting)
                                          return Text('');
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) {
                                                  return FullScreenWidget(
                                                    child: GestureDetector(
                                                      onVerticalDragEnd:
                                                          (details) {
                                                        if (details
                                                                .primaryVelocity! <
                                                            0) {
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: PhotoViewGallery
                                                          .builder(
                                                        itemCount: 1,
                                                        builder:
                                                            (context, index) {
                                                          return PhotoViewGalleryPageOptions(
                                                            imageProvider:
                                                                NetworkImage(
                                                                    UserData
                                                                        .photoURLPath!),
                                                            minScale:
                                                                PhotoViewComputedScale
                                                                        .contained *
                                                                    0.8,
                                                            maxScale:
                                                                PhotoViewComputedScale
                                                                        .covered *
                                                                    2.0,
                                                            heroAttributes:
                                                                PhotoViewHeroAttributes(
                                                                    tag:
                                                                        'photoTag'),
                                                          );
                                                        },
                                                        backgroundDecoration:
                                                            BoxDecoration(
                                                          color: Colors.black,
                                                        ),
                                                        pageController:
                                                            PageController(),
                                                        scrollPhysics:
                                                            BouncingScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Hero(
                                              tag: 'photoTag',
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                backgroundImage: NetworkImage(
                                                    UserData.photoURLPath!),
                                                radius: 90,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 145, right: 115),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.camera_alt),
                                          onPressed: () {
                                            showModalBottomSheet<void>(
                                                context: context,
                                                isDismissible: true,
                                                builder:
                                                    (BuildContext context) =>
                                                        bottomSheet());
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 280,
                              height: 50,
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: FutureBuilder(
                                      future: _name(),
                                      builder: ((context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting)
                                          return Text('');
                                        return TextFormField(
                                          focusNode: nameFocusNode,
                                          onChanged: (value) {
                                            try {
                                              updateName(value);
                                            } catch (e) {
                                              print(e.toString());
                                            }
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(0),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                          controller: myName,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              child: FutureBuilder(
                                future: _email(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) return Text('');
                                  return Text(
                                    '${UserData.email}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                        height: 235,
                        width: MediaQuery.of(context).size.width,
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
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20, top: 20, bottom: 8),
                                child: Text(
                                  AppLocalizations.of(context)!.aboutyourself,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(
                                height: 10,
                                color: Color.fromARGB(255, 77, 77, 77),
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Container(
                              child: FutureBuilder(
                                future: _aboutYourself(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) return Text('');
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: 14,
                                      right: 10,
                                    ),
                                    child: TextFormField(
                                      focusNode: aboutYourselfFocusNode,
                                      controller: aboutYourselfController,
                                      maxLength: 300,
                                      minLines: 3,
                                      maxLines: 5,
                                      textAlign: TextAlign.left,
                                      keyboardType: TextInputType.multiline,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Courier New',
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(6),
                                        hintText: aboutYourselfController
                                                    .text ==
                                                ""
                                            ? AppLocalizations.of(context)!
                                                .youhavenothingaboutyourselfmessage
                                            : null,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        updateAboutYouselfAndName(value);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  //Удаление фотографии пользователя
  void removePhotoFromProfile() async {
    try {
      setState(() {
        Navigator.pop(context);
        UserData.photoURLPath =
            'https://firebasestorage.googleapis.com/v0/b/signinsearchat.appspot.com/o/UsersImages%2Fdefoltimegeforeveryone.jpeg?alt=media&token=3781473e-efb3-4610-9e30-c3c72559f120';
        _isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({'photoUrl': UserData.photoURLPath});
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message: AppLocalizations.of(context)!.photowasdeleted,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка при загрузке фотографии: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  //Обновление имени пользователя в реальном времени
  void updateName(String value) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({'name': value.trim()});
    UserData.name = value.trim();
  }

  //Обновление информации о себе в реальном времени
  void updateAboutYouselfAndName(String value) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({'about_yourself': value.trim()});
    UserData.aboutYourself = value.trim();
  }

  Future<void> takePhoto(ImageSource source) async {
    try {
      Navigator.pop(context);
      final image = await _picker.pickImage(
        source: source,
        imageQuality: 100,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (image == null) {
        return;
      } else {
        setState(() {
          _isLoading = true;
        });
      }

      _imageFile = File(image.path);

      if (_imageFile == null) {
        return;
      } else {
        final ref = FirebaseStorage.instance
            .ref()
            .child('UsersImages')
            .child(UserData.email! + '.jpeg');

        await ref.putFile(_imageFile!);
        UserData.photoURLPath = await ref.getDownloadURL();
        _imageFile = null;

        setState(() {
          UserData.photoURLPath = UserData.photoURLPath;
        });

        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'photoUrl': UserData.photoURLPath});

        setState(() {
          _isLoading = false;
        });

        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: AppLocalizations.of(context)!.photowaspublushed,
          ),
        );
      }
    } catch (e) {
      print('Ошибка при загрузке фотографии: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    UserData.photoURLPath = UserData.photoURLPath;
  }

  Future<void> _aboutYourself() async {
    aboutYourselfController.text = UserData.aboutYourself ?? '';
  }

  Future<void> _name() async {
    myName.text = UserData.name ?? '';
  }

  Future<void> _email() async {
    UserData.email = UserData.email ?? '';
  }
}
