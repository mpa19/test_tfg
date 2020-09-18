import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/DashboardVertical.dart';

class CarouselVerticalScreen extends StatefulWidget {

  @override
  _CarouselVerticalScreenState createState() => _CarouselVerticalScreenState();
}


class _CarouselVerticalScreenState extends State<CarouselVerticalScreen> {
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Carousel Vertical Images"),
        ),
      body:
               DashboardVertical()
    );
  }
}