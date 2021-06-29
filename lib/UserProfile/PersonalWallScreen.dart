import 'dart:convert';

import 'package:flutter_app/Boards/CreateBoardScreen.dart';
import 'package:flutter_app/NavigationBar/HamburgerMenu.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utilities/constants.dart';

import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../Boards/BoardScreen.dart';
import 'ContactsScreen.dart';


class PersonalWallScreen extends StatefulWidget {

  @override
  PersonalWallState createState() => PersonalWallState();

}

class PersonalWallState extends State<PersonalWallScreen> with SingleTickerProviderStateMixin {
  bool _gotImage = false;

  var dataGet;
  final storage = new FlutterSecureStorage();
  String _userName = "";

  List<Widget>_randomChildren;


  List<BoardClass> _bcList = new List<BoardClass>();


  List<BoardClass> _searchList = List();

  String _searchText = "";
  final TextEditingController _searchController = TextEditingController();



  @override
  initState() {
    super.initState();

    setState(() {
      _getBoards();
      _getImageUrl();

      _randomChildren = new List<Widget>();

      _searchList = _bcList;
    });


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
        else _image = "https://www.martabatalla.com/flutter/wenect/boardsImages/"+row['board_image'];

        setState(() {
          _bcList.add(new BoardClass(row['board_id'], row['board_name'], _image));
        });
      }
    }

      _userName = await storage.read(key: "name");
    setState(() {
    });
  }


  Widget _buildProfileImage(){
    return  Container(
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
                                  : Image.network("https://www.martabatalla.com/flutter/wenect/defaultuser.jpg", fit: BoxFit.fill),
                     )
                  ),
              )
            ]
          )
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
                pushNewScreen(
                  context,
                  screen: ContactScreen(),
                  withNavBar: false,
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
                      /*Navigator.push(context, MaterialPageRoute(
                          builder: (context) => BoardScreen(board: board, isVisible: true)
                      ),
                      );*/
                      pushNewScreen(
                        context,
                        screen: BoardScreen(board: board, isVisible: true, mine: true),
                        withNavBar: true,
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


  List<BoardClass> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _searchList = _bcList;
    } else {
      _searchList = _bcList
          .where((element) =>
      element.title.toLowerCase().contains(_searchText.toLowerCase()) ||
          element.title.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
      return _searchList;
    }
  }

  Widget _buildCreateBoardBtn() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 40.0),

        alignment: Alignment.centerRight,
        child: ButtonTheme(
          minWidth: 50,
          height: 55.0,
          child: RaisedButton(
            elevation: 2.0,
            onPressed: () {
              pushNewScreen(
                context,
                screen: CreateBoardScreen(),
                withNavBar: false,
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.blue[900],
            child:  Icon(Icons.add, color: Colors.white,)
          ),
        )
    );
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

    return Scaffold(
      endDrawer: HamburgerScreen(),
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
                      body: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          _buildNameText(),
                          _buildSearchTF(),
                          Expanded(child:_buildBoards()),
                            _buildCreateBoardBtn()
                        ],
                      ),
                    ),
                  )
                ),
              )
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
