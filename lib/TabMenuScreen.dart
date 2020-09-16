import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class TabMenuScreen extends StatefulWidget {

  @override
  _TabMenuScreenState createState() => _TabMenuScreenState();
}

class _TabMenuScreenState extends State<TabMenuScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Tab Menu with Firebase"),
        ),
      body:DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxHeight: 150.0),
              child: Material(
                color: Colors.red,
                child: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.directions_car)),
                    Tab(text: "DOS",),
                    Tab(icon: Icon(Icons.directions_bike)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Icon(Icons.directions_car), // First Tab
                  FlatButton(
                    child: Text("Button"),
                    onPressed: null,), // Second Tab
                  Text('Input and selections',style: TextStyle(color: Colors.black87)), // Third Tab
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}