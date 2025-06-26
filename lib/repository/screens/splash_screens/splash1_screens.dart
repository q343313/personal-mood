


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_mode_app/boxes/profilebox.dart';
import 'package:personal_mode_app/custom_widget/uihelpers.dart';
import 'package:personal_mode_app/repository/screens/home_screens/home_screens.dart';
import 'package:personal_mode_app/repository/screens/navigationbarscreens/navigationbarscreens.dart';
import 'package:personal_mode_app/repository/screens/profile_screens/profiles_screens.dart';

class Splash1Screens extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Splash1Screens();
  }
}

class _Splash1Screens extends State<Splash1Screens> with TickerProviderStateMixin{

  late final AnimationController _controller;
  late Animation sizeanimation;
  late Animation textanimation;


  Color textcolor = Colors.black;
  List<Color> color = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orangeAccent,
    Colors.pink,
    Colors.yellow,
    Colors.purple,
    Colors.deepPurple,
    Colors.black
  ];

  var index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(seconds: 8));
    sizeanimation = Tween(begin: 0.0,end: 300.0).animate(_controller);
    textanimation  =Tween(begin: 0.0,end: 38.0).animate(_controller);

    _controller.addListener(()=>setState(() {

    }));

    _controller.forward();
    change_color();
    change_screen();
  }

  Timer?colortimer;
  Timer?screentimer;

  change_color(){
    colortimer = Timer.periodic(Duration(milliseconds: 400), (_)=>setState(() {
      if(index >= 0 && index < 8){
        textcolor = color[index];
        index++;
      }else if(index == 8) {
        index = 0;
      }
    }));
  }

  change_screen(){
    screentimer  =Timer.periodic(Duration(seconds: 9), (_)=>
    Boxes.getprofiledata().isEmpty || Boxes.getprofiledata() == null?
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfilesScreens())):
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Navigationbarscreens()))
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose

    colortimer?.cancel();
    screentimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
            UiHelpers.Customimage(img: "mood1.png",widht: sizeanimation.value,height: sizeanimation.value),
           SizedBox(height: 15,),

           Text("Personal Mood App",
           style: TextStyle(
             fontSize: textanimation.value,
             color: textcolor,
             fontFamily: "bold"
           ),)
         ],
       ),
     ),
   );
  }

}