import 'dart:convert';

import 'package:flutter_app/RegisterUser/CreateProfileScreen.dart';
import 'package:flutter_app/UserProfile/ContactWallScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utilities/constants.dart';

import 'package:http/http.dart' as http;



class BoardScreen extends StatefulWidget {
  final boardId;
  final name;
  final isVisible;

  @override
  BoardScreen({Key key, @required this.boardId, @required this.name, @required this.isVisible}) : super(key: key);

  @override
  BoardState createState() => BoardState();

}

class BoardState extends State<BoardScreen> with SingleTickerProviderStateMixin {

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

    setState(() {
      _getFriends();
    });

    _userName = widget.name;
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

  _getFriends() async {
    final response = await http.post("https://www.martabatalla.com/flutter/wenect/getBoardUsers.php",
        body: {
          "id": widget.boardId
        });

    var dataUser = json.decode(response.body);

    if(dataUser.length>0) {
      for(var row in dataUser) {
        var _image;
        if(row['user_image'] == "") _image = "https://www.martabatalla.com/flutter/wenect/defaultuser.png";
        else _image = "https://www.martabatalla.com/flutter/wenect/profileImages/"+row['user_image'];
        setState(() {
          _bcList.add(new FriendClass(row['user_id'], row['user_name']+" "+row['user_second'], _image));
        });
      }
    }
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
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ContactWallScreen(userId: friend.id, name: friend.title)
                  ),
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


  /*_getImageUrl() async {
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
  }*/


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
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, size: 35,),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
              ),
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
                        _buildSearchTF(),
                        Expanded(
                          child: _buildFriends(),
                          ),
                      ],
                    ),
                  ),
                )
            ),
          ],
        ),
        floatingActionButton: Visibility(
          visible: widget.isVisible,
          child: FloatingActionButton(
            heroTag: "editBoard",
            onPressed: () {
              /*Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => CreateBoardScreen()
              ),
              );*/
            },
            child: Icon(Icons.edit),
            backgroundColor: Colors.green,
          ),
        )
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