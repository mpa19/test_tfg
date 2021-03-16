import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class HamburgerScreen extends StatefulWidget {

  @override
  HamburgerMenuState createState() => HamburgerMenuState();

}

class HamburgerMenuState extends State<HamburgerScreen> {

  final storage = new FlutterSecureStorage();

  _closeSession() async {
    await storage.write(key: "login", value: "false");
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => MyApp()
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Send request'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('About'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Close session',
                style: TextStyle(decoration: TextDecoration.underline,
                    color: Colors.red)),
            onTap: () {
              _closeSession();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

}