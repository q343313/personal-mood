


import 'package:hive/hive.dart';
part 'profilemodel.g.dart';

@HiveType(typeId: 0)
class ProfileModel{
  
  @HiveField(0)
  String name;
  @HiveField(1)
  String fullname;
  @HiveField(2)
  String image;
  @HiveField(3)
  int age;
  
  ProfileModel({
    required this.name,
    required this.fullname,
    required this.image,
    required this.age
});
  
}