
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:personal_mode_app/repository/screens/home_screens/home_screens.dart';
import 'package:personal_mode_app/repository/screens/navigationbarscreens/accountscreens.dart';
import 'package:personal_mode_app/repository/screens/settingscreens/settingscreens.dart';


class Navigationbarscreens extends StatefulWidget {
  const Navigationbarscreens({super.key});

  @override
  State<Navigationbarscreens> createState() => _NavigationbarscreensState();
}

class _NavigationbarscreensState extends State<Navigationbarscreens> {

  var index = 1;

  var screens = [
    Settingscreens(),
    HomeScreens(),
    Accountscreens()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          items: [
            Icon(CupertinoIcons.settings),
            Icon(Icons.home),
            Icon(Icons.person_rounded),
          ],
        height: 50,
        animationCurve: Curves.linear,
        backgroundColor: Colors.blue,
        color: Colors.blue,
        buttonBackgroundColor:Theme.of(context).brightness ==Brightness.dark
        ? Colors.black
        :  Colors.white,
        index: index,
      onTap: (value){
            setState(() {
              index = value;
            });
      },
      ),

      body: IndexedStack(
        index: index,
        children: screens,
      ),
    );

  }
}
