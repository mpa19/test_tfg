import 'dart:convert';

import 'package:flutter_app/NavigationBar/HamburgerMenu.dart';
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


  var dataGet;
  final storage = new FlutterSecureStorage();

  List<Widget>_randomChildren;


  List<FriendClass> _bcList = new List<FriendClass>();


  List<FriendClass> _searchList = List();

  String _searchText = "";
  final TextEditingController _searchController = TextEditingController();



  @override
  initState() {
    super.initState();


    setState(() {
      _getFriends();
    });

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

  _getFriends() async {
    final response = await http.post("https://www.martabatalla.com/flutter/wenect/getAllUsers.php",
        body: {
          "id":await storage.read(key: "id")
        });

    var dataUser = json.decode(response.body);

    if(dataUser.length>0) {
      for(var row in dataUser) {
        var _image;
        if(row['user_image'] == "") _image = "https://www.martabatalla.com/flutter/wenect/defaultuser.jpg";
        else _image = "https://www.martabatalla.com/flutter/wenect/profileImages/"+row['user_image'];
        setState(() {
          _bcList.add(new FriendClass(row['user_id'], row['user_name']+" "+row['user_second'], _image));
        });
      }
    }
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
          hintText: 'Enter a username',
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }

  Widget _buildFriends(){
    return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 2/4,
        children: <FriendClass>[
          for (var i in _searchList) i,
        ].map((FriendClass friend) {
          return
            GestureDetector(
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: ContactWallScreen(userId: friend.id, name: friend.title),
                    withNavBar: true,
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: friend.selected),
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage(friend.image), // put image
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        friend.title, // Main text on the image
                        style:
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                )
            );
        }).toList());
  }



  @override
  Widget build(BuildContext context) {
    _randomChildren = new List<Widget>();
    //_randomChildren.add(_buildSearchPeopleTF());

    return Scaffold(
      endDrawer: HamburgerScreen(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            "FTMP",
          style: TextStyle(fontSize: 35),
        ),
        backgroundColor: Color(0xFF73AEF5),
        elevation: 0.0,
        leading: new Container(),
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
                      _buildSearchPeopleTF(),
                      SizedBox(height: 10.0),
                      Expanded(child:_buildFriends()),
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