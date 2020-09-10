import 'package:flutter/material.dart';

import 'SelectImageScreen.dart';
import 'SharedPreferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
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
                  child: Text('Shared Preferences',style: TextStyle(color: Colors.white),
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
                  child: Text('Select an image',style: TextStyle(color: Colors.white),
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
                  child: Text('Carousel Images',style: TextStyle(color: Colors.white),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
