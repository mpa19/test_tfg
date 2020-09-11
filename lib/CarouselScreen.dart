import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Dashboard.dart';

class CarouselScreen extends StatefulWidget {

  @override
  _CarouselScreenState createState() => _CarouselScreenState();
}


class _CarouselScreenState extends State<CarouselScreen> {
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
          title: new Text("Carousel Images"),
        ),
      body: (currentIndex == 0)
          ? Dashboard()
          : (currentIndex == 1)
            ? Dashboard()
            : Dashboard()
    );
  }
}