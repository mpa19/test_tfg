import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarouselScreen extends StatefulWidget {

  @override
  _CarouselScreenState createState() => _CarouselScreenState();
}


class _CarouselScreenState extends State<CarouselScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Carousel Images"),
        )
    );
  }
}