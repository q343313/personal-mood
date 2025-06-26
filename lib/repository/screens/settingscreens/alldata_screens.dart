


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personal_mode_app/boxes/profilebox.dart';
import 'package:personal_mode_app/custom_widget/uihelpers.dart';
import 'package:personal_mode_app/models/datamodel/userdatamodel.dart';

class AllDataScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return _AllDataScreen();
  }


}

class _AllDataScreen extends State<AllDataScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: UiHelpers.Customtext(text: "List of All Data Dates",
            fontsuze: 20,
            fontfamily: "bold",
            context: context),
      ),
      body: Center(
        child: Column(
          children: [

            ValueListenableBuilder(
                valueListenable: Boxes.userdata().listenable(),
                builder: (context,Box box,_){
                  var data = box.values.toList().cast<DataModel>();
                  return Expanded(child: ListView.builder(itemCount: data.length,
                  itemBuilder: (context,index){
                    return CustomListDates(
                        title: "${data[index].dateTime.day.toString()}/${data[index].dateTime.month.toString()}/${data[index].dateTime.year.toString()}",
                        subtitle: data[index].daytitle.toString(),
                        callback: (){
                          deletevalue(data[index]);
                        }
                    );
                  },));
                }
            )

          ],
        ),
      ),
    );
  }

  Future deletevalue(DataModel user){
    return user.delete();
  }

}
class CustomListDates extends StatelessWidget {
   CustomListDates({super.key,required this.title,required this.subtitle,required this.callback});
   String title;
   String subtitle;
   VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: UiHelpers.Customtext(text: title,
          fontsuze: 20,
          fontfamily: "bold",
          context: context),
      subtitle: UiHelpers.Customtext(text: subtitle,
          fontsuze: 13,
          fontfamily: "bold",
          context: context),
      trailing: IconButton(onPressed: (){callback();}, icon: Icon(Icons.delete)),
    );
  }
}
