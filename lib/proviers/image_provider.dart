


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageProviders extends ChangeNotifier{

  File?image_path;
  bool gallery = false;
  final _picked = ImagePicker();

  DateTime dateTime  = DateTime.now();

  change_datetime(DateTime date){
    dateTime = date;
    notifyListeners();
  }

  change_galley(){
    if(gallery== false){
      gallery = true;
    }else {
      gallery = true;
    }
    notifyListeners();
  }

  change_camera(){
    if(gallery== true){
      gallery = false;
    }else {
      gallery = false;
    }
    notifyListeners();
  }

  Future upload_image(BuildContext context)async{
    try {

      var picked_image = await _picked.pickImage(source: gallery?ImageSource.gallery:ImageSource.camera,imageQuality: 80);

      if(picked_image != null){
        image_path = File(picked_image.path);
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Upload Successfully")));
      }else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Upload Failed")));
      }

    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something Wrong!!")));

    }
  }

}