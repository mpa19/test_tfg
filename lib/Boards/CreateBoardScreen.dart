import 'dart:io';

import 'package:flutter_app/utilities/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:image_picker/image_picker.dart';



class CreateBoardScreen extends StatefulWidget {

  @override
  CreateBoardState createState() => CreateBoardState();

}

class CreateBoardState extends State<CreateBoardScreen> with SingleTickerProviderStateMixin {

  var dataGet;
  final storage = new FlutterSecureStorage();

  List<Widget>_randomChildren;

  List<BoardClass> _bcList;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();


  File _image;
  final picker = ImagePicker();

  String _searchText = "";

  List<BoardClass> _searchList = List();


  @override
  void initState() {
    super.initState();
    _bcList = new List<BoardClass>();
    _bcList.add(BoardClass("GYM", 'assets/images/146651.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));
    _bcList.add(BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'));

    _searchList = _bcList;
    _randomChildren = new List<Widget>();

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


  Widget _buildProfileImage(){
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: Column(
            children: <Widget>[
              CircleAvatar(
                radius: 95,
                backgroundColor: Colors.blue[900],
                child: ClipOval(
                  child: SizedBox(
                      width: 185,
                      height: 185,
                      child: _image == null
                          ? Image.asset('assets/images/146651.jpg',
                              fit: BoxFit.fill
                            )
                          : Image.file(_image, fit: BoxFit.fill)
                  ),
                ),
              ),

              if(_image != null) _cancelPhoto()
              else SizedBox(height: 40.0),

              FloatingActionButton.extended(
                onPressed: () {
                  getImage();
                },
                label: Text('Add photo'),
                icon: Icon(Icons.add_a_photo),
              ),
            ]
        )
    );
  }

  getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery); // or ImageSource.camera to do a photo

    if(pickedFile.path != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget _cancelPhoto(){
    return Container(
      transform: Matrix4.translationValues(65.0, -40.0, 0.0),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.red,
        child: ClipOval(
          child: SizedBox(
              width: 180,
              height: 180,
              child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black87,),
                  onPressed: () {
                    setState(() {
                      _image = null;
                    });
                  }
              )
          ),
        ),
      ),
    );
  }


  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child:  TextField(
            controller: _nameController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        )
      ],
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
              hintText: 'Enter a friend name',
              hintStyle: kHintTextStyle,
            ),
          ),
        );
  }

  Widget _buildFriendText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 30.0),
        Text(
        'Add friends',
        style: kLabelStyle,
        ),
        SizedBox(height: 10.0),

      ]
    );
  }

  Widget _buildBoardTitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Create Board", // Main text on the image
              style:
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
              ),
            ),
          ]
      ),
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
                  setState(() {
                    if(board.selected == 0) board.setSelected(5);
                    else board.setSelected(0);
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: board.selected),
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


  @override
  Widget build(BuildContext context) {
    _randomChildren = new List<Widget>();
    _randomChildren.add(_buildBoardTitle());
    _randomChildren.add(_buildProfileImage());
    _randomChildren.add(_buildNameTF());

    return Scaffold(
      resizeToAvoidBottomPadding: false,

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
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFriendText(),
                        _buildSearchTF(),
                        SizedBox(height: 10.0),
                        Expanded(child: _buildBoards())
                      ],
                    )
                  ),
                )
            ),
          ],
        ),
    );
  }
}

class BoardClass {
  String title;
  String image;
  double selected = 0;

  BoardClass(String title, String image) {
    this.title = title;
    this.image = image;
  }

  setSelected(double selected){
    this.selected = selected;
  }
}