import 'package:flutter_application_1/Chat/ChatScreen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

bool _isLoading = false;

class ProfileToCheck extends StatefulWidget {
  final UserInfoToProfile datainfo;

  ProfileToCheck({required this.datainfo});

  @override
  _ProfileScreenCreateState createState() => _ProfileScreenCreateState();
}

class _ProfileScreenCreateState extends State<ProfileToCheck> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
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
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) {
                                              return FullScreenWidget(
                                                child: GestureDetector(
                                                  onVerticalDragEnd: (details) {
                                                    if (details
                                                            .primaryVelocity! <
                                                        0) {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child:
                                                      PhotoViewGallery.builder(
                                                    itemCount: 1,
                                                    builder: (context, index) {
                                                      return PhotoViewGalleryPageOptions(
                                                        imageProvider:
                                                            NetworkImage(widget
                                                                .datainfo
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
                                                widget.datainfo.photoURLPath!),
                                            radius: 90,
                                          ),
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
                                      child: Text(
                                    widget.datainfo.name!,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              child: Text(
                                '${widget.datainfo.email}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
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
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, top: 0, bottom: 8, right: 15),
                                  child: Text(
                                    widget.datainfo.aboutYourself == "" || widget.datainfo.aboutYourself == null
                                        ? AppLocalizations.of(context)!
                                            .youhavenothingaboutyourselfmessage
                                        : widget.datainfo.aboutYourself!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Courier New',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
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
}
