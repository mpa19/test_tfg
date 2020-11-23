import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SelectedScreen.dart';

class BoardScreen1 extends StatefulWidget {

  @override
  _BoardScreenState1 createState() => _BoardScreenState1();
}

class _BoardScreenState1 extends State<BoardScreen1> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Board"),
        ),

       body: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 2/4,
        children: <BoardClass>[
            BoardClass("GYM", 'assets/images/146651.jpg'), BoardClass("PROGRAMMERS", 'assets/images/39902.jpg'), BoardClass("ART DEALERS", 'assets/images/934713.jpg'),
            BoardClass("FRIENDS", 'assets/images/39902.jpg'), BoardClass("ARCHITECTS", 'assets/images/146651.jpg'), BoardClass("LEARNING", 'assets/images/39902.jpg'),
            BoardClass("BANK MANAGERS", 'assets/images/934713.jpg'), BoardClass("SOCIO", 'assets/images/146651.jpg'), BoardClass("MATHS", 'assets/images/39902.jpg'),
            BoardClass("GAMING", 'assets/images/146651.jpg')

        ].map((BoardClass board) {
          return
            GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SelectedScreen(text: board.title)
                  ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage(board.image), // put image
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        board.title, // Main text on the image
                        style:
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Subtext', // Subtext on the image
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
              )
          );
        }).toList())
    );
  }
}

class BoardClass {
  String title;
  String image;

  BoardClass(String title, String image) {
    this.title = title;
    this.image = image;
  }
}
