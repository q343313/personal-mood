



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_mode_app/custom_widget/uihelpers.dart';

import '../domain/constants/app_colors.dart';

class CustomCont extends StatelessWidget {
  const CustomCont({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.scaffolddarkmode
            : AppColors.scaffoldlightmode,
        shape: BoxShape.circle,
        border: Border.all(
            color:Theme.of(context).brightness == Brightness.dark
                ? AppColors.scaffoldlightmode
                : AppColors.scaffolddarkmode,
            width: 2
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined),
            UiHelpers.Customtext(text: "add image",
                fontsuze: 12,
                fontfamily: "bold",
                context: context)
          ],
        ),
      ),
    );
  }
}
class CustomImage extends StatelessWidget {
  CustomImage({super.key,required this.image});
  DecorationImage image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.scaffolddarkmode
            : AppColors.scaffoldlightmode,
        shape: BoxShape.circle,
        image: image,
        border: Border.all(
            color:Theme.of(context).brightness == Brightness.dark
                ? AppColors.scaffoldlightmode
                : AppColors.scaffolddarkmode,
            width: 2
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined),
            UiHelpers.Customtext(text: "Change image",
                fontsuze: 12,
                fontfamily: "bold",
                context: context)
          ],
        ),
      ),
    );
  }
}

