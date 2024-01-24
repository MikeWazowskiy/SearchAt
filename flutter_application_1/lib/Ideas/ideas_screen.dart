import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Ideas/Create%20Ideas/create_edit_idea.dart';
import 'package:flutter_application_1/Ideas/Idea%20card/idea_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IdeasScreen extends StatefulWidget {
  @override
  _IdeasScreenCreateState createState() => _IdeasScreenCreateState();
}

class _IdeasScreenCreateState extends State<IdeasScreen> {
  String tag = "";
  final currentUsser = FirebaseAuth.instance.currentUser;
  String? email;
  final FocusNode _searchFocusNode = FocusNode();

  _email() async {
    if (currentUsser != null)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUsser!.email)
          .get()
          .then((value) {
        email = value.data()!['email'];
      }).catchError((e) {
        print(e);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 35, right: 10, left: 10),
              child: Container(
                child: TextField(
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.search),
                    fillColor: Color.fromARGB(255, 241, 241, 241),
                    hintText: AppLocalizations.of(context)!.searchbytag,
                  ),
                  onChanged: (value) {
                    setState(() {
                      tag = value;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _searchFocusNode.unfocus();
                },
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('ideas')
                      .where('user_email', isNotEqualTo: currentUsser!.email)
                      .snapshots(),
                  builder: ((context, snapshot) {
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? Center(child: CircularProgressIndicator())
                        : snapshot.hasError
                            ? Center(child: Text('Something went wrong.'))
                            : ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final data = snapshot.requireData;
                                  final List tags = data.docs[index]['tags'];

                                  if (tag.isEmpty) {
                                    return GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CreateEditIdeaPage(
                                              data: data,
                                              index: index,
                                              editing: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: IdeaCard(data: data, index: index),
                                    );
                                  }
                                  if (tags
                                      .toString()
                                      .toLowerCase()
                                      .contains(tag.toLowerCase())) {
                                    return GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CreateEditIdeaPage(
                                              data: data,
                                              index: index,
                                              editing: true,
                                            ),
                                          ),
                                        );
                                      },
                                      child: IdeaCard(data: data, index: index),
                                    );
                                  }
                                  return Container();
                                },
                              );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 247, 96, 85),
        child: Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEditIdeaPage(
                editing: false,
              ),
            ),
          );
        },
      ),
    );
  }
}
