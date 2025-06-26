

import 'package:flutter/material.dart';
import 'package:personal_mode_app/domain/constants/app_colors.dart';

class AppThemes {

  static final ThemeData ligththemedata = ThemeData(

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.scaffoldlightmode
    ),

    scaffoldBackgroundColor: AppColors.scaffoldlightmode,

    brightness: Brightness.light,

    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.textlightmode),
      bodySmall: TextStyle(color: AppColors.textlightmode)
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonlightmode,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
      ),
    ),


  );

  static final ThemeData darkthemedata = ThemeData(

    scaffoldBackgroundColor: AppColors.scaffolddarkmode,

    brightness: Brightness.dark,

    textTheme: TextTheme(
      bodySmall: TextStyle(color: AppColors.textdarkmode),
      bodyLarge: TextStyle(color: AppColors.textdarkmode)
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttondarkmode,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
      ),

    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.scaffolddarkmode
    )
  );
}