import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IdeaCard extends StatelessWidget {
  final data;
  final int index;

  IdeaCard({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final currentUsser = FirebaseAuth.instance.currentUser;
    /*CollectionReference favorites =
        FirebaseFirestore.instance.collection('favorites');*/

    List tags = data.docs[index]['tags'];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${data.docs[index]['title']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.black, // Черный цвет текста
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.by}: ${data.docs[index]['user_email']}',
                      style: TextStyle(
                        color: Colors.grey, // Серый цвет текста
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${data.docs[index]['description']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87, // Черный цвет текста
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      spacing: 8,
                      children: tags
                          .map((element) => Chip(
                                label: Text(
                                  element,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Color.fromARGB(
                                    255, 247, 96, 85), // Цвет фона чипа
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors
                                        .transparent, // Устанавливаем прозрачный цвет границы
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.date}: ${data.docs[index]['date']}',
                      style: TextStyle(
                        color: Colors.grey, // Серый цвет текста
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     favorites.add({
              //       'user_email': currentUsser!.email,
              //       'idea_id': data.docs[index].id,
              //     });
              //   },
              //   splashColor: Colors.transparent,
              //   icon: Icon(
              //     Icons.favorite_border,
              //     size: 30,
              //     color: Colors.grey,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
