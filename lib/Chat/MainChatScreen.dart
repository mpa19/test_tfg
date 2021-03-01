import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_app/Chat/const.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'Chat.dart';
import '../utilities/Loading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainChatScreen extends StatefulWidget {
  @override
  State createState() => MainChatScreenState();
}

class MainChatScreenState extends State<MainChatScreen> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final ScrollController listScrollController = ScrollController();
  final storage = new FlutterSecureStorage();

  bool isLoading = false;
  bool isSearching = false;
  List<FriendClass> _searchList = List();

  String _searchText = "";
  final TextEditingController _searchController = TextEditingController();
  List<FriendClass> _bcList = new List<FriendClass>();

  @override
  Future<void> initState() {
    super.initState();
    _getFriends();

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
  Widget _buildTextChat(FriendClass context){
    return Container(
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue[900],
            child: ClipOval(
                child: SizedBox(
                    width: 45,
                    height: 45,
                    child:Image.network(context.image,fit: BoxFit.fill)
                )
            ),
          ),
          SizedBox(width: 15.0),
          Text(
            context.title,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text('CHATS')
            : TextField(
          onChanged: (value) {
            _searchList;
          },
          controller: _searchController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: "Search Friend Here",
              hintStyle: TextStyle(color: Colors.white)),
        ),
        centerTitle: true,
        actions: <Widget>[
          isSearching
              ? IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              setState(() {
                this.isSearching = false;
                _searchList = _bcList;
              });
            },
          )
              : IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                this.isSearching = true;
              });
            },
          )
        ],
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                itemCount: _searchList.length,

                itemBuilder: (context, index) {
                  final item = _searchList[index];

                  return ListTile(
                    title: _buildTextChat(item),
                    onTap: () {
                      pushNewScreen(
                        context,
                        screen: Chat(peerId: item.id, peerAvatar: item.image, peerName: item.title),
                        withNavBar: false,
                      );
                    }
                  );
                },
              )
            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            )
          ],
        ),
      ),
    );
  }
}


class FriendClass {
  String id;
  String title;
  String image;

  FriendClass(String id, String title, String image) {
    this.id = id;
    this.title = title;
    this.image = image;
  }
}