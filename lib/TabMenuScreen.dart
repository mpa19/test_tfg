import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabMenuScreen extends StatefulWidget {

  @override
  _TabMenuScreenState createState() => _TabMenuScreenState();
}

class _TabMenuScreenState extends State<TabMenuScreen>{

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

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
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Campus').snapshots(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData) return Text("Loading data...");
                      return Column(
                        children: [
                          Text(snapshot.data.documents[0].get('DisponiblesC')),
                          Text(snapshot.data.documents[0].get('DisponiblesM')),
                        ],
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Campus').snapshots(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData) return Text("Loading data...");
                      return Column(
                        children: [
                          Text(snapshot.data.documents[1].get('DisponiblesC')),
                          Text(snapshot.data.documents[1].get('DisponiblesM')),
                        ],
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Campus').snapshots(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData) return Text("Loading data...");
                      return Column(
                        children: [
                          Text(snapshot.data.documents[0].get('DisponiblesC')),
                          Text(snapshot.data.documents[0].get('DisponiblesM')),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}