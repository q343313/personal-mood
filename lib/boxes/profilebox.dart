

import 'package:hive/hive.dart';
import 'package:personal_mode_app/models/datamodel/userdatamodel.dart';
import 'package:personal_mode_app/models/profile_model/profilemodel.dart';

class Boxes{
  static Box<ProfileModel>getprofiledata()=>Hive.box<ProfileModel>("profiledata");
  static Box<DataModel>userdata()=>Hive.box<DataModel>("userdata");

}