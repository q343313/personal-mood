


import 'package:flutter/cupertino.dart';

class DataProviders extends ChangeNotifier{

  Map<String,dynamic> userdata = {};


  adduserdata(String title,opinion,bestpoints,desipoints,image,data){

    userdata["title"] = title;
    userdata["opin"] = opinion;
    userdata["best"] = bestpoints;
    userdata["desi"]  = desipoints;
    userdata["image"] = image;
    userdata["date"] = data;
    notifyListeners();

  }

}