

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personal_mode_app/boxes/profilebox.dart';
import 'package:personal_mode_app/custom_widget/uihelpers.dart';
import 'package:personal_mode_app/domain/constants/app_colors.dart';
import 'package:personal_mode_app/domain/cubits/theme_cubits.dart';
import 'package:personal_mode_app/models/profile_model/profilemodel.dart';
import 'package:personal_mode_app/repository/screens/profile_screens/profiles_screens.dart';
import 'package:personal_mode_app/repository/screens/settingscreens/settingscreens.dart';

class DrawerScreens extends StatefulWidget {
  const DrawerScreens({super.key});

  @override
  State<DrawerScreens> createState() => _DrawerScreensState();
}

class _DrawerScreensState extends State<DrawerScreens> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
      ? Colors.black
      : Colors.white,
      child: Column(
        children: [
          SizedBox(height: 40,),
          ValueListenableBuilder(
              valueListenable: Boxes.getprofiledata().listenable(),
              builder: (context,Box box,_){
                var data = box.values.toList().cast<ProfileModel>();
                if (data == null || data.isEmpty){
                  return Column(
                    children: [
                      UiHelpers.Customtext(text: "No Account Found",
                          fontsuze: 20,
                          fontfamily: "bold",
                          context: context)
                    ],
                  );
                }else{
                  return Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: FileImage(File(data[0].image.toString())),
                        radius: 80,
                      ),
                      SizedBox(height: 20,),
                      UiHelpers.Customtext(text: data[0].name.toString(),
                          fontsuze: 25,
                          fontfamily: "bold",
                          context: context),

                      UiHelpers.Customtext(text: data[0].fullname.toString(),
                          fontsuze: 16,
                          fontfamily: "bold",
                          context: context),
                    ],
                  );

                }

              }
          ),

          Divider(color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white10
            : Colors.black12,thickness: 2,),

          SizedBox(height: 10,),

          CustomListtiel(
              title: "Upgrade",
              icon: Icon(Icons.upgrade),
              callback: (){}),

          CustomListtiel(
              title: "Theme",
              icon: Icon(Icons.dark_mode_outlined,color: Colors.blue,),
              callback: (){
                BlocProvider.of<ThemeCubits>(context).toggletheme();
              }),

          CustomListtiel(
              title: "New Update",
              icon: Icon(Icons.update,color: Colors.blue,),
              callback: (){}),

          CustomListtiel(
              title: "Menu",
              icon: Icon(Icons.menu,color: Colors.blue,),
              callback: (){}),

          CustomListtiel(
              title: "Category",
              icon: Icon(Icons.category,color: Colors.blue,),
              callback: (){}),

          CustomListtiel(
              title: "Setting",
              icon: Icon(CupertinoIcons.settings,color: Colors.blue,),
              callback: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Settingscreens()));              }),

          CustomListtiel(
              title: "Delete Account",
              icon: Icon(CupertinoIcons.delete,color: Colors.blue,),
              callback: (){
                deletedialog();
              }),
          CustomListtiel(
              title: "Create New Account",
              icon: Icon(CupertinoIcons.profile_circled,color: Colors.blue,),
              callback: (){
                if(Boxes.getprofiledata().isNotEmpty){
                  Boxes.getprofiledata().clear();
                }else{
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfilesScreens()));
                }

              }),

        ],
      ),
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

class CustomListtiel extends StatelessWidget {
   CustomListtiel({super.key,required this.title,required this.icon,required this.callback});

  Icon icon;
  VoidCallback callback;
  String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){callback();},
      leading: icon,
      title: UiHelpers.Customtext(text: title,
          fontsuze: 17,
          fontfamily: "bold",
          context: context),

    );
  }
}
