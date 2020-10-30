import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:path/path.dart';

class SelectImageScreen extends StatefulWidget {

  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImageScreen> {
  File _image;
  final picker = ImagePicker();
  String msg = '';
  bool update = false;
  bool gotImage = false;

  @override
  void initState() {
    
  }

  Future<List> _uploadImage() async {
    await http.post(
        "https://www.martabatalla.com/flutter/wenect/profileImages/uploadImage.php",
        body: {
          "image": base64Encode(_image.readAsBytesSync()),
          "name": "1"+ extension(basename(_image.path)),
        });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery); // or ImageSource.camera to do a photo

    if(pickedFile.path != null) {
      setState(() {
        _image = File(pickedFile.path);
        update = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Select an image"),
        ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.red,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Color(0xff476cfb),
                    child: ClipOval(
                      child: SizedBox(
                          width: 180,
                          height: 180,
                          child: gotImage == true
                              ? Image.network("https://www.martabatalla.com/flutter/wenect/profileImages/1.jpg")
                              : _image == null
                                ? Image.asset('assets/images/defaultuser.png',
                                fit: BoxFit.fill
                                ) 
                                : Image.file(_image)
                      ),
                    ),
                  )
              ),
              ButtonTheme(
                  buttonColor: Color(0xFF031e39),
                  child: FlatButton(
                    color: Colors.blueGrey, //Color(0xFF81A483),
                    onPressed: () {
                      if(update) _uploadImage();

                      update = false;
                    },
                    child: Text("Upload Image", style: TextStyle(color: Colors.white),
                    ),
                  )
              ),
              ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
