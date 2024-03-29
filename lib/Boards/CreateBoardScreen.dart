import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/utilities/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

import '../UserProfile/PersonalWallScreen.dart';



class CreateBoardScreen extends StatefulWidget {

  @override
  CreateBoardState createState() => CreateBoardState();

}

class CreateBoardState extends State<CreateBoardScreen> with SingleTickerProviderStateMixin {
  bool _isPrivate = false;

  var _errorText;
  var dataGet;
  final storage = new FlutterSecureStorage();

  List<Widget>_randomChildren;

  List<FriendClass> _bcList = new List<FriendClass>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  File _image;
  final picker = ImagePicker();

  String _searchText = "";

  List<FriendClass> _searchList = List();

  bool _nameEmpty = false;


  @override
  void initState() {
    super.initState();
    _getFriends();

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

  _getFriends() async {
    final response = await http.post("https://www.martabatalla.com/flutter/wenect/getFriends.php",
        body: {
          "id": await storage.read(key: "id")
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


  Widget _buildProfileImage(){
    return Container(
        padding: EdgeInsets.symmetric(vertical: 0),
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
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
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

  Widget _errorName(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
          child: Text(
              _errorText,
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'OpenSans',
              )
          ),
        ),
      ],
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
              hintText: 'Enter your Board Name',
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
        //SizedBox(height: 30.0),
        Text(
        'Add friends',
        style: kLabelStyle,
        ),

        SizedBox(height: 10.0),

      ]
    );
  }

  Widget _buildBoardTitle() {
    return Stack(
      children: <Widget>[

        Column(
          children: <Widget>[
            SizedBox(height: 50.0),
            Row(
              children: [
              ],
            ),
            Text(
              "DETAILS",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 5.5,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ],
    );
  }


  Widget _buildBoards(){
    return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 2/4,
        children: <FriendClass>[
          for (var i in _searchList) i,
        ].map((FriendClass friend) {
          return
            GestureDetector(
                onTap: () {
                  setState(() {
                    if(friend.selected == 0) friend.setSelected(5);
                    else friend.setSelected(0);
                  });
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: this.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Creating board'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you wanna create this board?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _createBoardMysql();
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => PersonalWallScreen()
                ),
                );
              },
            ),
          ],
        );
      },
    );
  }


  _uploadImage(String _name) async {
    await http.post(
        "https://www.martabatalla.com/flutter/wenect/boardsImages/uploadImage.php",
        body: {
          "image": base64Encode(_image.readAsBytesSync()),
          "name": await storage.read(key: "id")+_name,
        });
  }

  _createBoardMysql() async {
    var _nameImage = "";
    if(_image != null) {
      _nameImage = _nameController.text + extension(basename(_image.path));
      await _uploadImage(_nameImage);
    }

    var response = await http.post("https://www.martabatalla.com/flutter/wenect/createBoard.php",
        body: {
          "id": await storage.read(key: "id"),
          "name": _nameController.text,
          "photo": await storage.read(key: "id")+_nameImage.toLowerCase(),
          "private": _isPrivate.toString()
    });

    for (var i in _searchList){
      if(i.selected>0) {
        await http.post("https://www.martabatalla.com/flutter/wenect/relationBoardUsers.php",
            body: {
              "user_id": i.id,
              "board_id": response.body.toString(),
            });
      }
    }
  }

  _checkData() async {
    _nameEmpty = false;

    if(_nameController.text == ""){
      setState(() {
        _errorText = 'Name can\'t be empty';
        _nameEmpty = true;
      });
    } else if(await _checkNameExist()){
      setState(() {
        _errorText = 'You already have a board with that name';
        _nameEmpty = true;
      });
    } else {
      _showMyDialog();
    }

    setState(() {});
  }

  Future<bool> _checkNameExist() async {
    var response = await http.post("https://www.martabatalla.com/flutter/wenect/getBoardExist.php",
        body: {
          "id": await storage.read(key: "id"),
          "name": _nameController.text,
        });

    var dataUser = json.decode(response.body);

    if(dataUser.length==0) {
      return false;
    } else return true;
  }


  Widget _buildPublicSw() {
    return Row(
      children: [
        SizedBox(height: 80),
        Text(
          "Make it Private",
          style: kLabelStyle,
        ),
        Switch(
        value: _isPrivate,
        onChanged:(value) {
          setState(() {
            _isPrivate = value;
          });
        })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _randomChildren = new List<Widget>();
    //_randomChildren.add(_buildAppBar());
    _randomChildren.add(_buildProfileImage());

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
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: IconButton(
                  color: Colors.red[800],
                  icon: Icon(Icons.close, size: 35,),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
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
                    body: Container(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBoardTitle(),
                          _buildNameTF(),
                          if(_nameEmpty) _errorName(),
                          _buildPublicSw(),
                          _buildFriendText(),
                          _buildSearchTF(),
                          SizedBox(height: 10.0),
                          Expanded(child: _buildBoards()),
                          //Expanded(child: _buildCreateBoardBtn())
                        ],
                      ),
                    )
                  ),
                )
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "createBoard",
          onPressed: () {
            _checkData();
            //_showMyDialog();
          },
          child: Icon(Icons.check),
          backgroundColor: Colors.green[900],
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