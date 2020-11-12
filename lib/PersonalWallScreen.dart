import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:http/http.dart' as http;

import 'SelectedScreen.dart';
import 'main.dart';


class PersonalWallScreen extends StatefulWidget {

  @override
  PersonalWallState createState() => PersonalWallState();

}

class PersonalWallState extends State<PersonalWallScreen> with SingleTickerProviderStateMixin {
  bool _gotImage = false;
  bool _boardContainer = true;


  var dataGet;
  final storage = new FlutterSecureStorage();

  var _colorNot;
  var _textNot;

  var _colorBoard;
  var _textBoard;


  TabController _tabController;

  @override
  void initState() {
    _colorNot = Colors.white;
    _textNot = Color(0xFF527DAA);
    _colorBoard = Colors.blue[900];
    _textBoard = Colors.white;

    _tabController = TabController(length: 2, vsync: this);
    _getImageUrl();
  }


  Widget _buildProfileImage(){
    return  Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            CircleAvatar(
                radius: 70,
                backgroundColor: Colors.blue[900],
                child: ClipOval(
                   child: SizedBox(
                      width: 130,
                      height: 130,
                      child: _gotImage == true
                                ? Image.network("https://www.martabatalla.com/flutter/wenect/profileImages/" + dataGet, fit: BoxFit.fill)
                                : Image.asset('assets/images/defaultuser.png', fit: BoxFit.fill),
                   )
                ),
            )
          ]
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

  /*Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _closeSession();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.red,
        child: Text(
          'Close session',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }*/

  Widget _buildContactsBtn() {
    return Container(
      //padding: EdgeInsets.symmetric(vertical: 5.0),
      //width: double.minPositive,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          //_closeSession();
        },
        padding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'CONTACTS',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 11.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsBtn() {
    return Container(
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          setState(() {
            _boardContainer = false;
            _colorBoard = Colors.white;
            _textBoard = Color(0xFF527DAA);
            _colorNot = Colors.blue[900];
            _textNot = Colors.white;
          });
        },
        padding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: _colorNot,
        child: Text(
          'Notifications',
          style: TextStyle(
            color: _textNot,
            letterSpacing: 1.5,
            fontSize: 11.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildBoardsBtn() {
    return Container(
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          setState(() {
            _boardContainer = true;
            _colorNot = Colors.white;
            _textNot = Color(0xFF527DAA);
            _colorBoard = Colors.blue[900];
            _textBoard = Colors.white;
          });
        },
        padding: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: _colorBoard,
        child: Text(
          'Boards',
          style: TextStyle(
            color: _textBoard,
            letterSpacing: 1.5,
            fontSize: 11.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }



  Widget _buildNameText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
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
    );
  }

  Widget _buildBoards(){
    return Container(

        /*child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 2/4,
            children: <BoardClass>[
              BoardClass("GYM", 'assets/images/146651.jpg'), BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'), BoardClass("ART DEALERS", 'assets/images/934713.jpg'),
              BoardClass("FRIENDS", 'assets/images/39902.jpg'), BoardClass("ARCHITECTS", 'assets/images/146651.jpg'), BoardClass("LEARNING", 'assets/images/39902.jpg'),
              BoardClass("BANK MANAGERS", 'assets/images/934713.jpg'), BoardClass("SOCIO", 'assets/images/146651.jpg'), BoardClass("MATHS", 'assets/images/39902.jpg'),
              BoardClass("GAMING", 'assets/images/146651.jpg')

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
            }).toList())*/
    );
  }

  Widget _buildNotifications(){
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Text("Notifications")
    );
  }

  Widget _buildTabMenu(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 9,
            child: _buildBoardsBtn()
          ),
          Expanded(
            flex: 1,
              child: SizedBox(height: 5.0)),

          Expanded(
            flex: 9,
            child: _buildNotificationsBtn()
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
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
                height: double.infinity,
                child: Column(
                        children: <Widget>[
                          SizedBox(height: 45.0),
                          Container(
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _buildProfileImage(),
                                _buildContactsBtn(),
                                _buildNameText(),
                                _buildTabMenu(),
                                if(_boardContainer) _buildBoards()
                                else _buildNotifications()
                              ],
                            ),
                          )
                        ]
                    )
                ),
            ],
          ),
        ),
      ),
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