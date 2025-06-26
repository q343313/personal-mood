
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:personal_mode_app/boxes/profilebox.dart';
import 'package:personal_mode_app/custom_widget/uihelpers.dart';
import 'package:personal_mode_app/domain/constants/app_colors.dart';
import 'package:personal_mode_app/models/profile_model/profilemodel.dart';
import 'package:personal_mode_app/proviers/image_provider.dart';
import 'package:personal_mode_app/repository/screens/home_screens/home_screens.dart';
import 'package:personal_mode_app/repository/screens/navigationbarscreens/navigationbarscreens.dart';
import 'package:provider/provider.dart';

import '../../../custom_widget/customwidgets.dart';

class ProfilesScreens extends StatefulWidget {
  const ProfilesScreens({super.key});

  @override
  State<ProfilesScreens> createState() => _ProfilesScreensState();
}

class _ProfilesScreensState extends State<ProfilesScreens> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController fullnamecontrolle = TextEditingController();
  TextEditingController agecontroller=  TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageProviders>(
      builder: (context,value,child)=>
      Scaffold(
        appBar: AppBar(
          title: UiHelpers.Customtext(text: "Profiles Screens",
              fontsuze: 23,
              fontfamily: "bold",
              context: context),
        ),

        body: Center(
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      optionimage(context, (){
                        value.change_galley();
                        value.upload_image(context);
                        Navigator.pop(context);
                      }, (){
                        value.change_camera();
                        value.upload_image(context);
                        Navigator.pop(context);
                      });
                    },
                    child: value.image_path == null || value.image_path!.path.isEmpty
                        ?CustomCont():CustomImage(image: DecorationImage(image: FileImage(File(value.image_path!.path).absolute),fit: BoxFit.cover)),
                  ),
              
                  SizedBox(height: 20,),
              
                  UiHelpers.Customtextfield(hinttext: "Name",
                      controller: namecontroller,
                      textinputtype: TextInputType.text,
                      prefficicon: Icon(Icons.person_rounded),
                      context: context),
                  SizedBox(height: 15,),
              
                  UiHelpers.Customtextfield(hinttext: "Email",
                      controller: fullnamecontrolle,
                      textinputtype: TextInputType.text,
                      prefficicon: Icon(Icons.account_circle),
                      context: context),
                  SizedBox(height: 15,),
                  UiHelpers.Customtextfield(hinttext: "Age",
                      controller: agecontroller,
                      textinputtype: TextInputType.number,
                      prefficicon: Icon(Icons.accessibility_new_outlined),
                      context: context)
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: UiHelpers.Customelevatedbutton(buttonname: "Create Account",
            callback: (){

          if(_formkey.currentState!.validate()){

              var age = int.parse(agecontroller.text);
              final data = ProfileModel(
                  name: namecontroller.text,
                  fullname: fullnamecontrolle.text,
                  image: value.image_path!.path.toString(),
                  age: age
              );

              final box = Boxes.getprofiledata();
              box.add(data);

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Navigationbarscreens()));

              namecontroller.clear();
              fullnamecontrolle.clear();
              agecontroller.clear();
              value.image_path = null;
            }

          }

            ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

Future optionimage(BuildContext context,VoidCallback gallrycall,VoidCallback camearacal)
{
  return showDialog(
      context: context,
      builder: (context){
        return SimpleDialog(
          backgroundColor: Theme.of(context).brightness== Brightness.dark
          ? Colors.white24
          :Colors.white,
          children: [
            Padding(padding: EdgeInsets.only(left: 15),
            child: UiHelpers.Customtextbutton(buttonname: "Gallery",
                callback: (){
                  gallrycall();
                }),),
            SizedBox(height: 10,),
            Padding(padding: EdgeInsets.only(left: 15),
              child: UiHelpers.Customtextbutton(buttonname: "Camera",
                  callback: (){
                    camearacal();
                  }),),
          ],
        );
      });
}

