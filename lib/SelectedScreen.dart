import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectedScreen extends StatelessWidget {
  final String text;

  @override
  SelectedScreen({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Selected Board Screen"),
      ),
      body: Text(text),
    );
  }
}