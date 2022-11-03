import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/create_edit_idea.dart';

class DescriptionPage extends StatefulWidget {
  final String description;

  DescriptionPage({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  final _descrtiptionController = TextEditingController();

  @override
  void initState() {
    _descrtiptionController.text = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'Description',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.grey[50],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            size: 30,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Center(
              child: InkWell(
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: _descrtiptionController,
              maxLines: 20,
              autofocus: true,
              decoration: InputDecoration.collapsed(
                hintText:
                    'Describe your idea in more detail. Tell us what you use for development, and what skills are missing. It is important for other users to know what your idea is in order to understand whether it suits them. But do not forget that it is not necessary to tell something very secret.',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateEditIdeaPage(
                        description: _descrtiptionController.text),
                  ),
                );
              },
              child: Text(
                'Save',
                style: TextStyle(fontSize: 24),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                backgroundColor: Colors.green,
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
    );
  }
}
