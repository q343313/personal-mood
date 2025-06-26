
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:personal_mode_app/custom_widget/uihelpers.dart';
import 'package:personal_mode_app/domain/constants/app_colors.dart';
import 'package:personal_mode_app/proviers/dataproviders.dart';
import 'package:provider/provider.dart';

class DetailScreens extends StatefulWidget {
  const DetailScreens({super.key});

  @override
  State<DetailScreens> createState() => _DetailScreensState();
}

class _DetailScreensState extends State<DetailScreens> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProviders>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: UiHelpers.Customtext(
            text: "Mood Details",
            fontsuze: 20,
            fontfamily: "bold",
            context: context,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start
              children: [
                CustomContImage(
                  image: DecorationImage(
                    image: FileImage(
                      File(value.userdata["image"].toString()),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24), // Increased spacing

                CustomCardText(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Padding inside the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                      children: [
                        Align(
                          alignment: Alignment.centerRight, // Align date to the right
                          child: UiHelpers.Customtext(
                            text: value.userdata["date"].toString(),
                            fontsuze: 18,
                            fontfamily: "bold",
                            context: context,
                          ),
                        ),
                        const SizedBox(height: 16),

                        UiHelpers.Customtext(
                          text: "Best Points",
                          fontsuze: 22,
                          fontfamily: "bold",
                          context: context,
                        ),
                        const SizedBox(height: 8),
                        Text( // Using Text widget directly for content with wrap
                          value.userdata["best"].toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                        const Divider(height: 32, thickness: 1), // Adjusted divider properties

                        UiHelpers.Customtext(
                          text: "Desired Points", // Clarified "Desi Points" to "Desired Points"
                          fontsuze: 22,
                          fontfamily: "bold",
                          context: context,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          value.userdata["desi"].toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        ),
                        const Divider(height: 32, thickness: 1), // Adjusted divider properties
                        const SizedBox(height: 16),

                        RowFormat(head: "Day Title", title: value.userdata["title"].toString()),
                        RowFormat(head: "Your Opinion", title: value.userdata["opin"].toString()), // Clarified "Day opinion"
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomContImage extends StatelessWidget {
  const CustomContImage({super.key, required this.image});

  final DecorationImage image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250, // Slightly reduced height for better balance
      decoration: BoxDecoration(
        image: image,
        borderRadius: BorderRadius.circular(16), // Softer rounded corners
        boxShadow: [ // Added a subtle shadow for depth
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}



class CustomCardText extends StatelessWidget {
  const CustomCardText({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Consistent elevation
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Consistent rounded corners
      child: child,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.scaffolddarkmode
          : AppColors.scaffoldlightmode,
    );
  }
}

class RowFormat extends StatelessWidget {
  const RowFormat({super.key, required this.head, required this.title});

  final String head;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), // Adjusted padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: UiHelpers.Customtext(
                  text: head,
                  fontsuze: 18,
                  fontfamily: "bold",
                  context: context,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.right, // Align title to the right
                  style: TextStyle(
                    fontSize: 16, // Consistent font size
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.hintdarkmode.withOpacity(0.5) // Softer divider in dark mode
              : AppColors.hintlightmode.withOpacity(0.5), // Softer divider in light mode
          thickness: 1, // Thinner divider
          indent: 4, // Indent for a cleaner look
          endIndent: 4, // Indent for a cleaner look
        ),
      ],
    );
  }
}



//
//
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:personal_mode_app/custom_widget/uihelpers.dart';
// import 'package:personal_mode_app/domain/constants/app_colors.dart';
// import 'package:personal_mode_app/proviers/dataproviders.dart';
// import 'package:provider/provider.dart';
//
// class DetailScreens extends StatefulWidget {
//   const DetailScreens({super.key});
//
//   @override
//   State<DetailScreens> createState() => _DetailScreensState();
// }
//
// class _DetailScreensState extends State<DetailScreens> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<DataProviders>(
//       builder: (context,value,child)=>
//       Scaffold(
//         appBar: AppBar(
//           title: UiHelpers.Customtext(text: "Detail Screens",
//               fontsuze: 20,
//               fontfamily: "bold",
//               context: context),
//         ),
//         body: Center(
//           child:Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//
//               CustomContImage(image: DecorationImage(image: FileImage(File(
//                 value.userdata["image"].toString()
//               )),fit: BoxFit.cover)),
//               SizedBox(height: 18,),
//
//               CustomCardText(child: Column(
//                 children: [
//                   UiHelpers.Customtext(text: value.userdata["date"].toString(),
//                       fontsuze: 20,
//                       fontfamily: "bold",
//                       context: context),
//                   SizedBox(height: 10,),
//                   UiHelpers.Customtext(text: "Best Points",
//                       fontsuze: 22,
//                       fontfamily: "bold",
//                       context: context),
//                  Wrap(
//                    children: [
//                      UiHelpers.Customtext(text: value.userdata["best"].toString(),
//                          fontsuze: 14,
//                          context: context),
//                    ],
//                  ),
//                   Divider(color:Theme.of(context).brightness == Brightness.dark
//                       ? AppColors.hintdarkmode
//                       : AppColors.hintlightmode ,thickness: 2,),
//
//                   UiHelpers.Customtext(text: "Desi Points",
//                       fontsuze: 22,
//                       fontfamily: "bold",
//                       context: context),
//                   Wrap(
//                     children: [
//                       UiHelpers.Customtext(text: value.userdata["desi"].toString(),
//                           fontsuze: 14,
//                           context: context),
//                     ],
//                   ),
//                   Divider(color:Theme.of(context).brightness == Brightness.dark
//                       ? AppColors.hintdarkmode
//                       : AppColors.hintlightmode ,thickness: 2,),
//                   SizedBox(height: 10,),
//
//                   RowFormat(head: "Day Title", title: value.userdata["title"].toString()),
//                   RowFormat(head: "Day opinion", title: value.userdata["opin"].toString())
//                 ],
//               ))
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CustomContImage extends StatelessWidget {
//    CustomContImage({super.key,required this.image});
//
//    DecorationImage image;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 300,
//       decoration: BoxDecoration(
//         image: image,
//         borderRadius: BorderRadius.circular(30)
//       ),
//     );;
//   }
// }
//
// class CustomCardText extends StatelessWidget {
//    CustomCardText({super.key,required this.child});
//
//   Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 10,
//       child: child,
//       color: Theme.of(context).brightness == Brightness.dark
//       ? AppColors.scaffolddarkmode
//       : AppColors.scaffoldlightmode,
//     );
//   }
// }
//
// class RowFormat extends StatelessWidget {
//    RowFormat({super.key,required this.head,required this.title});
//
//   String head;
//   String title;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             UiHelpers.Customtext(text: head,
//                 fontsuze: 20,
//                 fontfamily: "bold",
//                 context: context),
//             UiHelpers.Customtext(text: title,
//                 fontsuze: 15,
//                 fontfamily: "bold",
//                 context: context)
//           ],
//         ),),
//         Divider(color:Theme.of(context).brightness == Brightness.dark
//             ? AppColors.hintdarkmode
//             : AppColors.hintlightmode ,thickness: 2,)
//       ],
//     );
//   }
// }
//
//
//
