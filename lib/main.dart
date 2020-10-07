import 'package:flutter/material.dart';
import 'package:flutter_app/BoardScreen.dart';
import 'package:flutter_app/CarouselVerticalScreen.dart';
import 'package:flutter_app/LogInScreen.dart';
import 'package:flutter_app/push_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_app/generated/l10n.dart';


import 'CarouselScreen.dart';
import 'SearchScreen.dart';
import 'SelectImageScreen.dart';
import 'SharedPreferences.dart';
import 'TabMenuScreen.dart';
import 'generated/l10n.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    PushNotificationsManager();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
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
                          builder: (context) => LogInScreen()
                      ),
                      );
                    },
                    child: Text('Log in',style: TextStyle(color: Colors.white),
                    ),
                  ),
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
