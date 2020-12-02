import 'package:flutter/material.dart';
import 'package:flutter_app/Boards/CreateBoardScreen.dart';
import 'package:flutter_app/UserProfile/PersonalWallScreen.dart';


class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {

    Widget child ;
    if(tabItem == "Page1")
      child = PersonalWallScreen();
    else if(tabItem == "Page2")
      child = CreateBoardScreen();
    else if(tabItem == "Page3")
      child = PersonalWallScreen();

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) => child
        );
      },
    );
  }
}