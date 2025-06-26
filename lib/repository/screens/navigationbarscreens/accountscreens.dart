

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personal_mode_app/boxes/profilebox.dart';
import 'package:personal_mode_app/custom_widget/uihelpers.dart';
import 'package:personal_mode_app/domain/constants/app_colors.dart';
import 'package:personal_mode_app/models/profile_model/profilemodel.dart';
import 'package:personal_mode_app/repository/screens/profile_screens/profiles_screens.dart';
import 'package:personal_mode_app/repository/screens/home_screens/drawer_screens.dart';


class Accountscreens extends StatefulWidget {
  const Accountscreens({super.key});

  @override
  State<Accountscreens> createState() => _AccountscreensState();
}

class _AccountscreensState extends State<Accountscreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: UiHelpers.Customtext(
            text: "Account",
            fontsuze: 20,
            fontfamily: "bold",
            context: context),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20,),
            ValueListenableBuilder(
                valueListenable: Boxes.getprofiledata().listenable(),
                builder: (context,Box box,_){
                  var data = box.values.toList().cast<ProfileModel>();
                  if (data == null || data.isEmpty){
                    return UiHelpers.Customtext(text: "No Account Found",
                        fontsuze: 20,
                        fontfamily: "bold",
                        context: context);
                  }
                  else{
                    var elemant = data[0];
                    return Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: FileImage(File(elemant.image.toString())),
                          radius: 100,
                        ),
                        SizedBox(height: 10,),

                        UiHelpers.Customtext(text: elemant.name.toString(),
                            fontsuze: 20,
                            fontfamily: "bold",
                            context: context),
                        UiHelpers.Customtext(text: elemant.fullname.toString(),
                            fontsuze: 15,
                            fontfamily: "bold",
                            context: context),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              UiHelpers.Customtext(text:"${elemant.name.toString()} age",
                                  fontsuze: 18,
                                  fontfamily: "bold",
                                  context: context),
                              UiHelpers.Customtext(text: "${elemant.age.toString()}Years",
                                  fontsuze: 18,
                                  fontfamily: "bold",
                                  context: context)
                            ],
                          ),
                        ),
                        Divider(color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.hintdarkmode
                            : AppColors.hintlightmode,)
                      ],
                    );
                  }

                }
            ),

          ],
        ),
      ),
      floatingActionButton:Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          UiHelpers.Customtextbutton(buttonname: "Create New Account",
              callback: (){
            Boxes.getprofiledata().clear();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfilesScreens()));
              }),
          UiHelpers.Customtextbutton(buttonname: "Logout",
              callback: (){
            deletedialog();
              }),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future deletedialog(){
    return showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: UiHelpers.Customtext(text: "Delete",
                fontsuze: 20,
                fontfamily: "bold",
                context: context),
            content:UiHelpers.Customtext(text: "Are you sure to delete your account.if you delete account you must be created new account",
                fontsuze: 13,
                context: context) ,
            actions: [
              UiHelpers.Customtextbutton(
                  color: Colors.red,
                  buttonname: "Delete",
                  callback: (){
                    Boxes.getprofiledata().clear();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your Account Deleted Succesfully")));
                    Navigator.pop(context);

                  }),
              UiHelpers.Customtextbutton(
                  color: Colors.blue,
                  buttonname: "Cancel", callback: (){
                Navigator.pop(context);
              })
            ],
          );
        });
  }

}
