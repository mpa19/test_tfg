import 'dart:convert';

import 'package:flutter_app/RegisterUser/CreateProfileScreen.dart';
import 'package:flutter_app/UserProfile/ContactWallScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utilities/constants.dart';

import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';




class MainWallScreen extends StatefulWidget {

  @override
  MainWallState createState() => MainWallState();

}

class MainWallState extends State<MainWallScreen> with SingleTickerProviderStateMixin {

  bool _gotImage = false;

  var dataGet;
  final storage = new FlutterSecureStorage();
  String _userName;

  List<Widget>_randomChildren;


  List<FriendClass> _bcList = new List<FriendClass>();


  List<FriendClass> _searchList = List();

  String _searchText = "";
  final TextEditingController _searchController = TextEditingController();



  @override
  initState() {
    super.initState();


    //_getImageUrl();

    _randomChildren = new List<Widget>();

    _searchList = _bcList;

    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _searchText = "";
          _buildSearchList();
        });
      } else {
        setState(() {
          _searchText = _searchController.text;
          _buildSearchList();
        });
      }
    });
  }


  List<FriendClass> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _searchList = _bcList;
    } else {
      _searchList = _bcList
          .where((element) =>
      element.title.toLowerCase().contains(_searchText.toLowerCase()) ||
          element.title.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
      print('${_searchList.length}');
      return _searchList;
    }
  }

  Widget _buildSearchBoardTF() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: kBoxDecorationStyle,
      height: 60.0,
      child:  TextField(
        controller: _searchController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          hintText: 'Enter a board name',
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }

  Widget _buildSearchPeopleTF() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: kBoxDecorationStyle,
      height: 60.0,
      child:  TextField(
        controller: _searchController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          hintText: 'Enter a name',
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    _randomChildren = new List<Widget>();
    //_randomChildren.add(_buildBoardImage());
    //_randomChildren.add(_buildNameText());
    _randomChildren.add(_buildSearchPeopleTF());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("WENECT"),
        backgroundColor: Color(0xFF73AEF5),
        elevation: 0.0,
        leading: new Container(),
        actions: [
          IconButton(
              icon: Icon(Icons.menu, size: 35,),
              onPressed: () {
                Navigator.of(context).pop();
              }
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF73AEF5),
                  Color(0xFF61A4F1),
                  Color(0xFF478DE0),
                  Color(0xFF398AE5),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),

          Container(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, _) {
                    return [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          _randomChildren,
                        ),
                      ),
                    ];
                  },
                  // You tab view goes here
                  body: Column(
                    children: <Widget>[
                      _buildSearchBoardTF(),
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}

class FriendClass {
  String id;
  String title;
  String image;
  double selected = 0;

  FriendClass(String id, String title, String image) {
    this.id = id;
    this.title = title;
    this.image = image;
  }

  setSelected(double selected){
    this.selected = selected;
  }
}