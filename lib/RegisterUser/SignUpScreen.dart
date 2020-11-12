import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/RegisterUser/CreateProfileScreen.dart';
import 'package:flutter_app/utilities/constants.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class SignUpScreen extends StatefulWidget {

  @override
  SignUpState createState() => SignUpState();

}

class SignUpState extends State<SignUpScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _emailEmpty = false;
  bool _passwordEmpty = false;
  bool _passwordMatch = false;
  bool _emailInUse = false;

  String errorMessageEmail = "";

  var _list;

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child:  TextField(
            controller: _emailController,
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

  Widget _errorEmail(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
          child: Text(
              'Email can´t be empty',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'OpenSans',
              )
          ),
        ),
      ],
    );
  }

  Widget _errorPassword(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 6, 0, 4),
          child: Text(
              'Password can´t be empty',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'OpenSans',
              )
          ),
        ),
      ],
    );
  }

  Widget _emailUsed(){
    return Container(
      color: Colors.amberAccent,
      width: double.infinity,
      padding: EdgeInsets.all(5.0),
      child: Row(
        children: [
          SizedBox(height: 30.0),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.error_outline),
          ),
          Expanded(
              child: Text(errorMessageEmail)
          ),
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _emailInUse = false;
                });
              }
          )
        ],
      ),
    );
  }

  Widget _errorPassowrdMatch(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
          child: Text(
              'Password doesn´t match',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'OpenSans',
              )
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTFRepeat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _passwordRepeatController,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password Again',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _signUpCheck();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Next',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }


  /*Widget _buildCancelBtn() {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          Navigator.pop(_scaffoldKey.currentContext);
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color:Color(0xFF527DAA),
        child: Text(
          'Cancel',
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

  _signUpCheck()  async {
      _emailEmpty = false;
      _passwordEmpty = false;
      _passwordMatch = false;
      _emailInUse = false;

      if(_emailController.text == "" || _passwordController.text == "") {
        setState(() {
          if(_emailController.text == "") _emailEmpty = true;
          if(_passwordController.text == "") _passwordEmpty = true;
        });

      } else if(_passwordController.text != _passwordRepeatController.text) {
        setState(() {
          _passwordMatch = true;
        });
      } else if(_checkEmail()) {
        await _checkUser();
      } else {
        setState(() {
          errorMessageEmail = "Bad Message Format";
          _emailInUse = true;
        });
      }

      setState((){});
  }

  final storage = new FlutterSecureStorage();

  _codePassword() async {
    final response = await http.post("https://www.martabatalla.com/flutter/wenect/createPassword.php",
        body: {
          "password": _passwordController.text
        });

    var dataUser = json.decode(response.body);
    _list = dataUser[0].values.toList();

    await storage.write(key: "password", value: _list[0]);
    await storage.write(key: "email", value: _emailController.text);
    await storage.write(key: "remember", value: "false");
    await storage.write(key: "login", value: "false");


    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateProfileScreen()),
    );
  }

  _checkUser() async {
    final response = await http.post("https://www.martabatalla.com/flutter/wenect/selectUser.php",
        body: {
          "email": _emailController.text
        });

    var dataUser = json.decode(response.body);

    if(dataUser.length==0){
      await _codePassword();
    } else{
      setState(() {
        errorMessageEmail = "Email already registered";
        _emailInUse = true;
      });
    }
  }

  bool _checkEmail()  {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text);
    return emailValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                          if(_emailInUse) _emailUsed(),
                          Container(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                _buildEmailTF(),
                                if(_emailEmpty) _errorEmail(),
                                SizedBox(height: 30.0),
                                _buildPasswordTF(),
                                if(_passwordEmpty) _errorPassword(),
                                _buildPasswordTFRepeat(),
                                if(_passwordMatch) _errorPassowrdMatch(),
                                _buildSignUpBtn(),
                                //_buildCancelBtn()
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
