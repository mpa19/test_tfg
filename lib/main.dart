import 'package:flutter/material.dart';
import 'package:flutter_app/BoardScreen.dart';
import 'package:flutter_app/CarouselVerticalScreen.dart';
import 'package:flutter_app/generated/l10n.dart';


import 'CarouselScreen.dart';
import 'SearchScreen.dart';
import 'SelectImageScreen.dart';
import 'SharedPreferences.dart';
import 'TabMenuScreen.dart';
import 'generated/l10n.dart';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  /*final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("MAIN"),
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                  buttonColor: Color(0xFF031e39),
                  child: FlatButton(
                    color: Colors.blueGrey, //Color(0xFF81A483),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SharedPreferencesScreen()
                      ),
                      );
                    },
                    child: Text(S.current.preferencesText, style: TextStyle(color: Colors.white),
                    ),
                  )
              ),
              ButtonTheme(
                  buttonColor: Color(0xFF031e39),
                  child: FlatButton(
                    color: Colors.blueGrey, //Color(0xFF81A483),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SelectImageScreen()
                      ),
                      );
                    },
                    child: Text(S.current.selImageText, style: TextStyle(color: Colors.white),
                    ),
                  )
              ),
              ButtonTheme(
                  buttonColor: Color(0xFF031e39),
                  child: FlatButton(
                    color: Colors.blueGrey, //Color(0xFF81A483),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CarouselScreen()
                      ),
                      );
                    },
                    child: Text('Carousel Images',style: TextStyle(color: Colors.white),
                    ),
                  )
              ),
              ButtonTheme(
                  buttonColor: Color(0xFF031e39),
                  child: FlatButton(
                    color: Colors.blueGrey, //Color(0xFF81A483),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SearchScreen()
                      ),
                      );
                    },
                    child: Text('Search Bar',style: TextStyle(color: Colors.white),
                    ),
                  )
              ),
              ButtonTheme(
                  buttonColor: Color(0xFF031e39),
                  child: FlatButton(
                    color: Colors.blueGrey, //Color(0xFF81A483),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => TabMenuScreen()
                      ),
                      );
                    },
                    child: Text('Tab Menu with Firebase',style: TextStyle(color: Colors.white),
                    ),
                  )
              ),
              ButtonTheme(
                  buttonColor: Color(0xFF031e39),
                  child: FlatButton(
                    color: Colors.blueGrey, //Color(0xFF81A483),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CarouselVerticalScreen()
                      ),
                      );
                    },
                    child: Text('Carousel Vertical Images',style: TextStyle(color: Colors.white),
                    ),
                  )
              ),
              ButtonTheme(
                buttonColor: Color(0xFF031e39),
                child: FlatButton(
                  color: Colors.blueGrey, //Color(0xFF81A483),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => BoardScreen()
                    ),
                    );
                  },
                  child: Text('Board',style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }


}
