import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesScreen extends StatefulWidget {

  @override
  _SharedPreferencesState createState() => _SharedPreferencesState();
}

TextEditingController _controller;

Future<bool> saveNamePreferences(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("key", name);

  return prefs.commit();
}


Future<String> getNamePreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String name = prefs.getString("key");

  return name;
}



class _SharedPreferencesState extends State<SharedPreferencesScreen> {
  String _name = "";


  @override
  void initState() {
    getNamePreferences().then(updateName);
  }

  void updateName(String name) {
    if(name != null)  {
      setState(() {
        this._name = name;
      });
    }

  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Shared Preferences"),
        ),
        body: new ListView(
          children: [
            TextField(
              controller: _controller,
              onSubmitted: (String value) async {
                saveNamePreferences(value);
              },
            ),
            Text(_name)
          ],
        )
    );
  }
}



