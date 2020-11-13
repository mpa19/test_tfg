import 'dart:convert';

import 'package:flutter_app/BoardScreen.dart';
import 'package:flutter_app/Boards/CreateBoardScreen.dart';
import 'package:flutter_app/RegisterUser/CreateProfileScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utilities/constants.dart';

import 'package:http/http.dart' as http;

import 'SelectedScreen.dart';


class PersonalWallScreen extends StatefulWidget {

  @override
  PersonalWallState createState() => PersonalWallState();

}

class PersonalWallState extends State<PersonalWallScreen> with SingleTickerProviderStateMixin {
  bool _gotImage = false;

  var dataGet;
  final storage = new FlutterSecureStorage();
  var _isVisible;

  List<Widget>_randomChildren;

  TabController _tabController;

  List<BoardClass> _bcList;

  String _searchText = "";
  final TextEditingController _searchController = TextEditingController();

  List<BoardClass> _searchList = List();

  @override
  void initState() {
    super.initState();
    _bcList = new List<BoardClass>();
    _bcList.add(BoardClass("GYM", 'assets/images/146651.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));

    _isVisible = true;
    _getImageUrl();
    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(_handleTabSelection);
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


  Widget _buildProfileImage(){
    return  GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => CreateProfileScreen()
          ),
          );
      },
      child:Container(
          padding: EdgeInsets.symmetric(vertical: 0),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 30.0),
              CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.blue[900],
                  child: ClipOval(
                     child: SizedBox(
                        width: 105,
                        height: 105,
                        child: _gotImage == true
                                  ? Image.network("https://www.martabatalla.com/flutter/wenect/profileImages/" + dataGet, fit: BoxFit.fill)
                                  : Image.asset('assets/images/defaultuser.png', fit: BoxFit.fill),
                     )
                  ),
              )
            ]
          )
      )
    );
  }

  /*_closeSession() async {
    await storage.write(key: "login", value: "false");
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => MyApp()
    ),
    );
  }*/


  Widget _buildContactsBtn() {
    return Container(
      child: ButtonTheme(
        minWidth: 50,
        height: 28.0,
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => BoardScreen()
            ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Text(
            'CONTACTS',
            style: TextStyle(
              color: Color(0xFF527DAA),
              letterSpacing: 1.5,
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      )
    );
  }


  Widget _buildNameText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
          child: Text(
            'MARC PEREZ',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 5.5,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
        )
      )
    );
  }

/*
BoardClass("GYM", 'assets/images/146651.jpg'), BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'), BoardClass("ART DEALERS", 'assets/images/934713.jpg'),
              BoardClass("FRIENDS", 'assets/images/39902.jpg'), BoardClass("ARCHITECTS", 'assets/images/146651.jpg'), BoardClass("LEARNING", 'assets/images/39902.jpg'),
              BoardClass("BANK MANAGERS", 'assets/images/934713.jpg'), BoardClass("SOCIO", 'assets/images/146651.jpg'), BoardClass("MATHS", 'assets/images/39902.jpg'),
              BoardClass("GAMING", 'assets/images/146651.jpg')
*/
  Widget _buildBoards(){
    return GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 2/4,
            children: <BoardClass>[
              for (var i in _searchList) i,
            ].map((BoardClass board) {
              return
                GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SelectedScreen(text: board.title)
                      ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage(board.image), // put image
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            board.title, // Main text on the image
                            style:
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Subtext', // Subtext on the image
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )
                );
            }).toList());
  }


  _getImageUrl() async {
    final response = await http.post("https://www.martabatalla.com/flutter/wenect/profileImages/selectImage.php",
        body: {
          "id":   await storage.read(key: "id")
        });

    var dataUser = json.decode(response.body);

    if(dataUser.length>0){
      for(var row in dataUser) {
        setState(() {
          dataGet = row['user_image'];
          if(dataGet!="") _gotImage = true;
        });
      }
    }
  }

  Widget _buildNotifications(){
    return ListView(
      padding: EdgeInsets.zero,
      children: Colors.primaries.map((color) {
        return Container(color: color, height: 150.0);
      }).toList(),
    );
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
            setState(() {
              _isVisible = true;
            });
          break;
        case 1:
          setState(() {
            _isVisible = false;
          });
          break;
      }
    }
  }

  List<BoardClass> _buildSearchList() {
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

  Widget _buildSearchTF() {

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
          hintText: 'Enter a friend name',
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    _randomChildren = new List<Widget>();
    _randomChildren.add(_buildProfileImage());
    _randomChildren.add(_buildContactsBtn());
    _randomChildren.add(_buildNameText());

    return Scaffold(
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
                padding: const EdgeInsets.all(40),
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
                          TabBar(
                            controller: _tabController,
                            tabs: [
                              Tab(text: 'Boards'),
                              Tab(text: 'Notifications'),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          if(_isVisible) _buildSearchTF(),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildBoards(),
                                _buildNotifications()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                )
              ),
            ],
      ),

      floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => CreateBoardScreen()
              ),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue[900],
          ),
      )
    );
  }
}

class BoardClass {
  String title;
  String image;

  BoardClass(String title, String image) {
    this.title = title;
    this.image = image;
  }
}
