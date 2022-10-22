import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class IdeasScreen extends StatefulWidget {
  @override
  _IdeasScreenCreateState createState() => _IdeasScreenCreateState();
}

class _IdeasScreenCreateState extends State<IdeasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Search",
          style: TextStyle(
            color: Color.fromARGB(255, 77, 77, 77),
          ),
        ),
        actions: [
          IconButton(
            color: Color.fromARGB(255, 77, 77, 77),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: Text('Ideas'),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    'Unreal Engine',
    'C#',
    'Flutter',
    'Java',
    'JavaScript',
    'Kotlin',
    'Swift',
    'Unity',
    'Python',
    'C++',
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResult(BuildContext context) {
    List<String> matchQuery = [];
    for (var language in searchTerms) {
      if (language.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(language);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var language in searchTerms) {
      if (language.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(language);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }
}
