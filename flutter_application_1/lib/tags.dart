import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

var suggestTag = [
  "Unity",
  "Flutter",
  "Dart",
  "C#",
  "Java",
  "JavaScript",
  "Python",
  "SQL",
  "DataBases",
  "Web",
  "Sites",
  "Mobile",
  "Applications",
  "Art",
  "Drawing",
  "SoundDesign",
  "GameDesign",
  "C++",
];

class TagStateController extends GetxController {
  var listTags = List<String>.empty(growable: true).obs;
}

class TagsField extends StatefulWidget {
  @override
  _TagsFieldState createState() => _TagsFieldState();
}

class _TagsFieldState extends State<TagsField> {
  final controller = Get.put(TagStateController());
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: textController,
            onEditingComplete: () {
              controller.listTags.add(textController.text);
              textController.clear();
            },
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Tag',
            ),
          ),
          suggestionsCallback: (String pattern) {
            return suggestTag.where((element) =>
                element.toLowerCase().contains(pattern.toLowerCase()));
          },
          onSuggestionSelected: (String suggestion) =>
              controller.listTags.add(suggestion),
          itemBuilder: (context, itemData) {
            return ListTile(
              leading: Icon(Icons.tag),
              title: Text(itemData),
            );
          },
        ),
        SizedBox(height: 10),
        Obx(() => controller.listTags.length == 0
            ? Center(
                child: Text('No Tag selected'),
              )
            : Wrap(
                children: controller.listTags
                    .map(
                      (element) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Chip(
                          label: Text(element),
                          deleteIcon: Icon(Icons.clear),
                          onDeleted: () => controller.listTags.remove(element),
                        ),
                      ),
                    )
                    .toList(),
              ))
      ],
    );
  }
}
