import 'package:flutter/material.dart';

import 'package:flutter_application_1/Screens/ideas_screen';

import 'package:flutter_application_1/Screens/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final screens = [
    IdeasScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        tooltip: 'Increment',
        child: Icon(
          Icons.add,
          color: Color.fromARGB(255, 77, 77, 77),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Color.fromARGB(255, 77, 77, 77),
        selectedItemColor: Color.fromARGB(255, 255, 219, 15),
        currentIndex: _currentIndex,
        onTap: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
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
      body: screens[_currentIndex],
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
