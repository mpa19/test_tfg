import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'NavigationBar/MainWallScreen.dart';
import 'file:///C:/Users/Marc/.AndroidStudio1.3/flutter_app/lib/UserProfile/PersonalWallScreen.dart';
import 'file:///C:/Users/Marc/.AndroidStudio1.3/flutter_app/lib/RegisterUser/SignUpScreen.dart';

import 'package:flutter_app/utilities/constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: LogInScreen(),
        initialRoute: '/'
    );
  }
}

class LogInScreen extends StatefulWidget {

  @override
  LogInState createState() => LogInState();

}

class LogInState extends State<LogInScreen> {
  bool _rememberMe = false;
  bool _errorLogin = false;
  bool _emailEmpty = false;
  bool _passwordEmpty = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final storage = new FlutterSecureStorage();

  var _passwordCoded;


  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  _checkLogin() async {
    if(await storage.read(key: "login") == "true") {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => MainWallScreen()
      ),
      );
    }

    if(await storage.read(key: "remember") == "true") {
      String _email = await storage.read(key: "email");
      _emailController.text = _email;
    }


  }

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
          child: TextField(
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

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
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
          _signInWithEmailAndPassword();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
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


  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => SignUpScreen()
        ),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginError(){
    return Container(
      child: Column(
        children: [
          Container(
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
                    child: Text("Email and/or Password incorrects")
                ),
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _errorLogin = false;
                      });
                    }
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _checkUserExist() async {
    final response = await http.post("https://www.martabatalla.com/flutter/wenect/loginUser.php",
        body: {
          "email": _emailController.text,
          "password": _passwordCoded[0]
        });

    var dataUser = json.decode(response.body);

    if(dataUser.length>0){
      await storage.write(key: "id", value: dataUser[0]['user_id']);
      await storage.write(key: "name", value: dataUser[0]['user_name']+" "+dataUser[0]['user_second']);
      if(_rememberMe) {
        await storage.write(key: "email", value: dataUser[0]['user_email']);
        await storage.write(key: "remember", value: "true");
      } else {
        await storage.write(key: "email", value: "");
        await storage.write(key: "remember", value: "false");
      }
      await storage.write(key: "login", value: "true");

      Navigator.push(context, MaterialPageRoute(
          builder: (context) => PersonalWallScreen()
      ),
      );
    } else {
      setState(() {
        _errorLogin = true;
      });
    }

  }

  _codePassword() async {
    final response = await http.post("https://www.martabatalla.com/flutter/wenect/createPassword.php",
        body: {
          "password": _passwordController.text
        });

    var dataUser = json.decode(response.body);
    _passwordCoded = dataUser[0].values.toList();
  }

  void _signInWithEmailAndPassword() async {
    _emailEmpty = false;
    _passwordEmpty = false;
    _errorLogin = false;

    if(_emailController.text == "" || _passwordController.text == "") {
      setState(() {
        if(_emailController.text == "") _emailEmpty = true;
        if(_passwordController.text == "") _passwordEmpty = true;
      });
    } else {
      await _codePassword();
      await _checkUserExist();
    }

    setState(() {});
  }

  Widget _errorName(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
          child: Text(
              'Email can\'t be empty',
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
          padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
          child: Text(
              'Password can\'t be empty',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'OpenSans',
              )
          ),
        ),
      ],
    );
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
                      if(_errorLogin) _loginError(),
                      Container(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                  Image.asset('assets/images/logo.png',
                                      fit: BoxFit.fill
                                  ),
                                  SizedBox(height: 30.0),
                                  _buildEmailTF(),
                                  if(_emailEmpty) _errorName(),
                                  SizedBox(height: 30.0),
                                  _buildPasswordTF(),
                                  if(_passwordEmpty) _errorPassword(),
                                  _buildForgotPasswordBtn(),
                                  _buildRememberMeCheckbox(),
                                  _buildLoginBtn(),
                                  _buildSignupBtn(),
                              ]
                          )
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

