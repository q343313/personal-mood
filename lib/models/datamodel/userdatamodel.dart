


import 'package:hive/hive.dart';
part 'userdatamodel.g.dart';

@HiveType(typeId: 1)
class DataModel extends HiveObject{

  @HiveField(0)
  String daytitle;

  @HiveField(1)
  String bestpoints;

  @HiveField(2)
  String desipoints;

  @HiveField(3)
  DateTime dateTime;

  @HiveField(4)
  String image;

  @HiveField(5)
  String youropiniononday;
  
  DataModel({
   required this.daytitle,
   required this.bestpoints,
   required this.desipoints,
   required this.dateTime,
   required this.image ,
    required this.youropiniononday
});
  
}