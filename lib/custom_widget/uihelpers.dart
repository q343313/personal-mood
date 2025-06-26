




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_mode_app/domain/constants/app_colors.dart';

class UiHelpers{

  static Customimage({
    required String img,
    double?widht,
    double?height
}){
    return Image(image: AssetImage("assets/images/$img"),width: widht??300,height: height??300,);
  }

  static Customcircleavatar({
    required double radius,
    String?img,
    Color?color,
    Widget?child
}){
    return CircleAvatar(
      backgroundImage: AssetImage("assets/images/$img"),
      backgroundColor: color??AppColors.buttondarkmode,
      radius: radius,
      child: child,
    );
  }

  static Customtext({
    required String text,
    required double fontsuze,
    String?fontfamily,
    required BuildContext context,

}){
    return Text(
      text,
      style: TextStyle(
        fontSize: fontsuze,
        fontFamily: fontfamily??"regular",
        color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.textdarkmode
            : AppColors.textlightmode
      ),
    );
  }

  static Customtextbutton({
    required String buttonname,
    required VoidCallback callback,
    double?fontsize,
    Color?color,

}){
    return InkWell(
      onTap: (){callback();},
      child: Text(
        buttonname,
        style: TextStyle(
          fontFamily: "bold",
          fontSize: fontsize??20,
          color: color??AppColors.buttondarkmode
        ),
      ),
    );
  }

  static Customelevatedbutton({
    required String buttonname,
    required VoidCallback callback,
    double?widht,
    double?height,
    Color?color,
}){
    return SizedBox(
      height: height??55,
      width: widht??270,
      child: ElevatedButton(onPressed: (){callback();}, child: Text(
        buttonname,
        style: TextStyle(
          fontSize: 23,
          fontFamily: "bold",
          color: AppColors.scaffoldlightmode,
        ),
      )),
    );
  }

  static Customtextfield({
    required String hinttext,
    required TextEditingController controller,
    required TextInputType textinputtype,
    required BuildContext context,
    Icon?prefficicon,
    IconButton?sufficicon,
    double?width,
    double?height,
  bool?  obstracttet,
    Function(String)?func
}){
    return SizedBox(
      width: width??370,
      height: height??55,
      child: Card(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white10
            : AppColors.scaffoldlightmode,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
        elevation: 10,
        child: TextFormField(
          validator: (value){
            if(value == null  || value.isEmpty){
              return "Please enter $hinttext";
            }
            return null;
          },
          controller: controller,
          keyboardType: textinputtype,
          onChanged: func,
            obscureText: obstracttet??false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hinttext,
            hintStyle: TextStyle(
              fontFamily: "bold",
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.hintdarkmode
                : AppColors.hintlightmode,
              fontSize: 15
            ),
            prefixIcon: prefficicon,
            suffixIcon: sufficicon
          ),
        ),
      ),

    );
  }
}