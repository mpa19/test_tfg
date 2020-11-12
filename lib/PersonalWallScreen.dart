import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:http/http.dart' as http;

import 'main.dart';


class PersonalWallScreen extends StatefulWidget {

  @override
  PersonalWallState createState() => PersonalWallState();

}

class PersonalWallState extends State<PersonalWallScreen> {
  bool _gotImage = false;
  var dataGet;
  final storage = new FlutterSecureStorage();


  @override
  void initState() {
    _getImageUrl();
  }


  Widget _buildProfileImage(){
    return  Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
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

  _closeSession() async {
    await storage.write(key: "login", value: "false");
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => MyApp()
    ),
    );
  }


  Widget _buildLoginBtn() {
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
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                        children: <Widget>[
                          SizedBox(height: 80.0),
                          Container(
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _buildProfileImage(),
                                _buildLoginBtn()
                              ],
                            ),
                          )
                        ]
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}