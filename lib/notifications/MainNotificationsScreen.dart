import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utilities/Loading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_app/Chat/const.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainNotificationsScreen extends StatefulWidget {
  @override
  State createState() => MainNotificationsScreenState();
}

class MainNotificationsScreenState extends State<MainNotificationsScreen> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final ScrollController listScrollController = ScrollController();
  final storage = new FlutterSecureStorage();

  bool isLoading = false;
  List<NotificationClass> _searchList = List();


  @override
  Future<void> initState() {
    super.initState();
    _getNotifications();

  }



  _getNotifications() async {
    /*final response = await http.post("https://www.martabatalla.com/flutter/wenect/getFriends.php",
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
    }*/
  }

  Widget _buildTextChat(NotificationClass context){
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
                      child:Image.network(context.tipo,fit: BoxFit.fill)
                  )
              ),
            ),
            SizedBox(width: 15.0),
            Text(
              context.description,
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
        title:
        Text('NOTIFICATIONS'),
        centerTitle: true,
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
                          /*pushNewScreen(
                            context,
                            screen: Chat(peerId: item.id, peerAvatar: item.image, peerName: item.title),
                            withNavBar: false,
                          );*/
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


class NotificationClass {
  String id;
  String description;
  String tipo;

  NotificationClass(String id, String description, String tipo) {
    this.id = id;
    this.description = description;
    this.tipo = tipo;
  }
}