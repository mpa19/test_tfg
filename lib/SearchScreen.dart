import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';


class SearchScreen extends StatefulWidget {
  final List<String> list = List.generate(10, (index) => "Text $index");

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: Search(widget.list));
            },
            icon: Icon(Icons.search),
          )
        ],
        centerTitle: true,
        title: Text('Search Bar'),
      ),
    );
  }
}

class Search extends SearchDelegate {

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  final List<String> listExample;
  Search(this.listExample);

  List<String> recentList = [];

  SharedPreferences prefs;

  saveRecentPreferences(String name) async {
    prefs = await SharedPreferences.getInstance();
    List<String> recent = await getRecentPreferences();
    recent.add(name);
    prefs.setStringList("recent", recent);
  }


  Future<List<String>> getRecentPreferences()  async {
    prefs = await SharedPreferences.getInstance();

    List<String> name = prefs.getStringList("recent");
    return name;
  }


  getRecent()  async {
    prefs = await SharedPreferences.getInstance();

    List<String> name = prefs.getStringList("recent");
    suggestionList = name;
  }

  List<String> suggestionList;

  @override
  Widget buildSuggestions(BuildContext context) {
    suggestionList = [];
    query.isEmpty
        ? getRecent()
        : suggestionList.addAll(listExample.where( // In the false case
          (element) => element.contains(query),
    ));

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: (){
            selectedResult = suggestionList[index];
            //if(!(await getRecentPreferences()).contains(selectedResult))
              saveRecentPreferences(selectedResult);
            showResults(context);
          },
        );
      },
    );
  }
}