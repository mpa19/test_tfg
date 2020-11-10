import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/utilities/constants.dart';
import 'package:image_picker/image_picker.dart';


class CreateProfileScreen extends StatefulWidget {

  @override
  CreateProfileState createState() => CreateProfileState();

}

class CreateProfileState extends State<CreateProfileScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();

  bool _nameEmpty = false;
  bool _secondNameEmpty = false;

  File _image;
  final picker = ImagePicker();

  Widget _buildProfileImage(){
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.blue[900],
                    child: ClipOval(
                      child: SizedBox(
                          width: 180,
                          height: 180,
                          child: _image == null
                              ? Image.asset('assets/images/defaultuser.png',
                              fit: BoxFit.fill
                          )
                              : Image.file(_image)
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
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

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery); // or ImageSource.camera to do a photo

    if(pickedFile.path != null) {
      setState(() {
        _image = File(pickedFile.path);
        //update = true;
      });
    }
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
          child: TextField(
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
              hintText: 'Enter your Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Second Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _secondNameController,
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
              hintText: 'Enter your Second Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }


  _createUser() {
    _nameEmpty = false;
    _secondNameEmpty = false;

    if(_checkTF()) {
      //
    }


  }

  bool _checkTF() {
    bool checked = true;

    if(_nameController.text == "") {
      setState(() {
        _nameEmpty = true;
      });
      checked = false;
    }

    if(_secondNameController.text == "") {
      setState(() {
        _secondNameEmpty = true;
      });
      checked = false;
    }

    return checked;
  }

  Widget _buildCreateBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _createUser();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Create Account',
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


  Widget _errorName(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
          child: Text(
              'Name can´t be empty',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'OpenSans',
              )
          ),
        ),
      ],
    );
  }


  Widget _errorSecondName(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
          child: Text(
              'Second Name can´t be empty',
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
                          Container(
                            padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _buildProfileImage(),
                                SizedBox(height: 10.0),
                                _buildNameTF(),
                                if(_nameEmpty) _errorName(),
                                SizedBox(height: 30.0),
                                _buildSecondNameTF(),
                                if(_secondNameEmpty) _errorSecondName(),
                                _buildCreateBtn(),
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
