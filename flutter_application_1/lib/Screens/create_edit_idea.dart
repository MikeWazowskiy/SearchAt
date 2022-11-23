import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/edit_description_page.dart';
import 'package:flutter_application_1/tags.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:get/get.dart';

class CreateEditIdeaPage extends StatefulWidget {
  final QuerySnapshot? data;
  final int? index;
  final bool editing;

  const CreateEditIdeaPage({
    Key? key,
    this.data,
    this.index,
    required this.editing,
  }) : super(key: key);

  @override
  _CreateEditIdeaPageState createState() => _CreateEditIdeaPageState();
}

class _CreateEditIdeaPageState extends State<CreateEditIdeaPage> {
  String? email;
  final controller = Get.put(TagStateController());
  final ideaTitleTextField = TextEditingController();

  var description = '';
  var contacts = [];
  final now = new DateTime.now();

  var icons = [
    Icons.email,
    Icons.telegram,
    Icons.whatsapp,
    Icons.facebook,
    Icons.smartphone
  ];
  void initState() {
    super.initState();
    ideaTitleTextField.text = widget.data?.docs[widget.index!]['title'] ?? '';
    description = widget.data?.docs[widget.index!]['description'] ?? '';
    LoadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference ideas = FirebaseFirestore.instance.collection('ideas');

    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              'Idea',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 15),
            widget.editing == true
                ? email == widget.data!.docs[widget.index!]['user_email']
                    ? TextFormField(
                        autofocus: false,
                        controller: ideaTitleTextField,
                        maxLength: 50,
                        decoration: InputDecoration(
                            labelText: 'Idea title',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear_rounded),
                              onPressed: () => ideaTitleTextField.clear(),
                            )),
                      )
                    : Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              ideaTitleTextField.text,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 209, 209, 209),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                : TextFormField(
                    autofocus: false,
                    controller: ideaTitleTextField,
                    maxLength: 50,
                    decoration: InputDecoration(
                        labelText: 'Idea title',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear_rounded),
                          onPressed: () => ideaTitleTextField.clear(),
                        )),
                  ),
            Text(
              'About',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 35),
            widget.editing == true
                ? email == widget.data!.docs[widget.index!]['user_email']
                    ? InkWell(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              description.isEmpty
                                  ? Text(
                                      'Idea description',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  : Text(
                                      description,
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              Divider(
                                height: 45,
                                thickness: 0.9,
                                color: Colors.grey[500],
                              ),
                            ],
                          ),
                        ),
                        onTap: () async {
                          final descriptionVal =
                              await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  DescriptionPage(description: description),
                            ),
                          );
                          setState(() {
                            description = descriptionVal;
                          });
                        },
                      )
                    : Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              description,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 209, 209, 209),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                      )
                : InkWell(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          description.isEmpty
                              ? Text(
                                  'Idea description',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                )
                              : Text(
                                  description,
                                  style: TextStyle(fontSize: 16),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          Divider(
                            height: 45,
                            thickness: 0.9,
                            color: Colors.grey[500],
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      final descriptionVal = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              DescriptionPage(description: description),
                        ),
                      );
                      setState(() {
                        description = descriptionVal;
                      });
                    },
                  ),
            SizedBox(height: 15),
            Text(
              'Tags',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 35),
            TagsField(),
            SizedBox(height: 10),
            Text(
              'Contacts',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: buildContacts(),
            ),
            IconButton(
                onPressed: (() => setState(() {
                      if (contacts.length < 3) {
                        contacts.add('');
                      }
                    })),
                icon: Icon(Icons.add)),
            widget.editing == false
                ? ElevatedButton(
                    onPressed: () {
                      ideas
                          .add(
                            {
                              'title': ideaTitleTextField.text.trim(),
                              'description': description.trim(),
                              'tags': controller.listTags,
                              'contacts': contacts,
                              'date': DateFormat('dd.MM.yyyy').format(now),
                              // Новое поле для добавления имейла
                              'user_email': email,
                            },
                          )
                          .then(
                            (value) => print('Idea added!'),
                          )
                          .catchError(
                              (error) => 'Failded to add the idea: $error');
                      Navigator.of(context).pop(context);
                      showTopSnackBar(
                        context,
                        CustomSnackBar.success(
                          message: "The idea has been successfully published!",
                        ),
                      );
                    },
                    child: Text(
                      'Publish',
                      style: TextStyle(fontSize: 25),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      backgroundColor: Color.fromARGB(255, 102, 192, 105),
                    ),
                  )
                : email == widget.data!.docs[widget.index!]['user_email']
                    ? Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showTopSnackBar(
                                context,
                                CustomSnackBar.success(
                                  message:
                                      "The idea has been successfully updated!",
                                ),
                              );
                              FirebaseFirestore.instance
                                  .collection('ideas')
                                  .doc(widget.data?.docs[widget.index!].id)
                                  .update(
                                {
                                  'title': ideaTitleTextField.text.trim(),
                                  'description': description.trim(),
                                  'tags': controller.listTags,
                                  'contacts': contacts,
                                  'date': DateFormat('dd.MM.yyyy').format(now),
                                },
                              );
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Save',
                              style: TextStyle(fontSize: 25),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              backgroundColor:
                                  Color.fromARGB(255, 102, 192, 105),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showTopSnackBar(
                                context,
                                CustomSnackBar.info(
                                  message:
                                      "The idea has been successfully deleted!",
                                ),
                              );
                              FirebaseFirestore.instance
                                  .collection('ideas')
                                  .doc(widget.data?.docs[widget.index!].id)
                                  .delete();
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(fontSize: 25),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              backgroundColor:
                                  Color.fromARGB(255, 192, 102, 102),
                            ),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }

  // Эта функция в реальном времени сохраняет инфу о текущем юзере и берет его имейл
  void LoadCurrentUser() async {
    final currentuser = await FirebaseAuth.instance.currentUser;
    setState(() {
      email = currentuser!.email;
    });
  }

  Widget buildContacts() => ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];

          return Card(
            key: Key(contact),
            elevation: 4,
            child: TextFormField(
              initialValue: contacts[index],
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  color: Colors.grey,
                  icon: Icon(Icons.delete),
                  onPressed: () => setState(() {
                    contacts.removeAt(index);
                  }),
                ),
                prefixIcon: IconButton(
                  icon: Icon(icons[0]),
                  color: Colors.grey,
                  onPressed: () => setState(() {}),
                ),
              ),
              onChanged: (value) {
                contacts[index] = value;
              },
            ),
          );
        },
      );
}
