import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class CommonFriendsScreen extends StatefulWidget {

  @override
  _CommonFriendsState createState() => _CommonFriendsState();
}

class _CommonFriendsState extends State<CommonFriendsScreen> {
  var msg='';
  var dataGet = '';

  Future<List> _getFriends() async {
    final response = await http.post("https://www.martabatalla.com/flutter/wenect/getdata.php");

    /*
    final response = await http.post("http://10.0.2.2/wenect/login.php", body: {
        "username": user.text,
        "password": pass.text,
    });
    */

    var datauser = json.decode(response.body);

    //print(datauser);
    if(datauser.length==0){
      setState(() {
        msg="Login Fail";
      });
    }else{
      for(var row in datauser){
        setState(() {
          dataGet += row['user_1'] + '\n';
        });
      }
    }
    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Common friends"),
        ),
        body: Center()
    );
  }
}