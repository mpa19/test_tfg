import 'dart:convert';

import 'package:flutter_app/RegisterUser/CreateProfileScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utilities/constants.dart';

import 'package:http/http.dart' as http;

import '../Boards/BoardScreen.dart';
import '../main.dart';


class ContactWallScreen extends StatefulWidget {
  final userId;
  final name;

  @override
  ContactWallScreen({Key key, @required this.userId, this.name}) : super(key: key);

  @override
  ContactWallState createState() => ContactWallState();

}

class ContactWallState extends State<ContactWallScreen> with SingleTickerProviderStateMixin {
  bool _gotImage = false;

  var dataGet;
  final storage = new FlutterSecureStorage();
  var _isVisible;
  String _userName = "";

  List<Widget>_randomChildren;

  TabController _tabController;

  List<BoardClass> _bcList = new List<BoardClass>();


  List<BoardClass> _searchList = List();

  String _searchText = "";
  final TextEditingController _searchController = TextEditingController();



  @override
  initState() {
    super.initState();

    setState(() {
      _getBoards();
    });

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

  _getBoards() async {
    final response = await http.post("https://www.martabatalla.com/flutter/wenect/getBoards.php",
        body: {
          "id": await storage.read(key: "id")
        });

    var dataUser = json.decode(response.body);

    if(dataUser.length>0) {
      for(var row in dataUser) {
        var _image;
        if(row['board_image'] == "") _image = "https://www.martabatalla.com/flutter/wenect/146651.jpg";
        else _image = "https://www.martabatalla.com/flutter/wenect/users/"+await storage.read(key: "id")+"/"+row['board_image'];
        _bcList.add(new BoardClass(row['board_id'], row['board_name'], _image));
      }
    }

    _userName = await storage.read(key: "name");

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

  _closeSession() async {
    await storage.write(key: "login", value: "false");
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => MyApp()
    ),
    );
  }


  Widget _buildContactsBtn() {
    return Container(
      child: ButtonTheme(
        minWidth: 50,
        height: 28.0,
        child: RaisedButton(
          elevation: 5.0,
          onPressed: () {
            _closeSession();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Text(
            'ADD FRIEND',
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


  Widget _buildNameText()  {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
          child: Text(
            _userName,
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
                          builder: (context) => BoardScreen(boardId: board.id, name: board.title)
                      ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: NetworkImage(board.image), // put image
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
          hintText: 'Enter a board name',
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
    //_randomChildren.add(_buildNameText());

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
              AppBar(
                backgroundColor: Colors.transparent,
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
                          _buildNameText(),
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
    );
  }
}

class BoardClass {
  String id;
  String title;
  String image;

  BoardClass(String id, String title, String image) {
    this.id = id;
    this.title = title;
    this.image = image;
  }
}
