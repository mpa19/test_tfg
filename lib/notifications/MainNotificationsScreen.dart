import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/UserProfile/ContactWallScreen.dart';
import 'package:flutter_app/utilities/Loading.dart';
import 'package:flutter_app/Chat/const.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainNotificationsScreen extends StatefulWidget {
  @override
  State createState() => MainNotificationsScreenState();
}

class MainNotificationsScreenState extends State<MainNotificationsScreen> {

  final storage = new FlutterSecureStorage();

  bool isLoading = false;
  List<NotificationClass> _searchList = List();


  @override
  Future<void> initState() {
    super.initState();
    _getNotifications();
  }


  _getNotifications() async {
    final response = await http.post("https://www.martabatalla.com/flutter/wenect/getNotifications.php",
        body: {
          "id": await storage.read(key: "id")
        });

    var dataUser = json.decode(response.body);

    if(dataUser.length>0) {
      for(var row in dataUser) {
        setState(() {
          _searchList.add(new NotificationClass(row['not_userFrom'], row['not_userToName'], row['not_desc'], row['not_tipo']));
        });
      }
    }
  }

  Widget _buildTextChat(NotificationClass context){
    return Container(
        child: Row(
          children: [
            ImageIcon(
              context.tipo == "0"
                  ? AssetImage('assets/images/addfriend.png')
                  : AssetImage('assets/images/addedfriend.png'),
              color: Colors.black,
              size: 40.0,
            ),
            SizedBox(width: 15.0),
            Text(
              context.userName + context.description,
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
                          pushNewScreen(
                            context,
                            screen: ContactWallScreen(userId: item.id, name: item.userName),
                            withNavBar: true,
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


class NotificationClass {
  String id;
  String userName;
  String description;
  String tipo;

  NotificationClass(String id, String userName, String description, String tipo) {
    this.id = id;
    this.userName = userName;
    this.description = description;
    this.tipo = tipo;
  }
}