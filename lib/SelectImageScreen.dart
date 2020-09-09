import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectImageScreen extends StatefulWidget {

  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImageScreen> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery); // or ImageSource.camera to do a photo

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Select an image"),
        ),
      body: Center(
        child: CircleAvatar(
          radius: 100,
          backgroundColor: Color(0xff476cfb),
          child: ClipOval(
            child: SizedBox(
              width: 180,
              height: 180,
                child: _image == null
                    ? Image.network("https://lh3.googleusercontent.com/proxy/OmGN2Zwo356GOtR3VG8QRmzV5DGyp2lyUSTi2PCIv6O_IQTTuigtfflNKqrKJSM3tnZ6_0M03ggCf5M93hO0zLro1xOUcw9r2BAswKdFtPaMDim60UIVmLQ",
                    fit: BoxFit.fill
                    )
                    : Image.file(_image)
            ),
          ),
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
