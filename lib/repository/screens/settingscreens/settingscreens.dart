

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_mode_app/boxes/profilebox.dart';
import 'package:personal_mode_app/custom_widget/uihelpers.dart';
import 'package:personal_mode_app/domain/constants/app_colors.dart';
import 'package:personal_mode_app/domain/cubits/theme_cubits.dart';
import 'package:personal_mode_app/models/datamodel/userdatamodel.dart';
import 'package:personal_mode_app/repository/screens/profile_screens/profiles_screens.dart';
import 'package:personal_mode_app/repository/screens/settingscreens/alldata_screens.dart';

class Settingscreens extends StatefulWidget {
  const Settingscreens({super.key});

  @override
  State<Settingscreens> createState() => _SettingscreensState();
}

class _SettingscreensState extends State<Settingscreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: UiHelpers.Customtext(
          text: "Settings", // Standard "Settings" title
          fontsuze: 22, // Slightly larger font size
          fontfamily: "bold",
          context: context,
        ),
        centerTitle: true, // Center the app bar title
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), // Added consistent padding
        child: Column(
          children: [
            // Section for General Settings
            _buildSettingsSection(
              context,
              title: "General",
              children: [
                CustomListTile(
                  title: "Total Days",
                  icon: const Icon(Icons.calendar_today_outlined), // More suitable icon
                  callback: () {
                  var box  =  Boxes.userdata();
                  box.values.toList().cast<DataModel>();
                   totaldaysdailog("you write ${box.length.toString()} days data in your personal mood app");
                  },
                ),
                CustomListTile(
                  title: "Day Dates List",
                  icon: const Icon(Icons.list_alt), // More suitable icon
                  callback: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AllDataScreen()));
                  },
                ),
                CustomListTile(
                  title: "Clear All Data",
                  icon: const Icon(CupertinoIcons.clear_circled),
                  callback: () {
                    _showClearAllDataConfirmation(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20), // Spacing between sections

            // Section for App Preferences
            _buildSettingsSection(
              context,
              title: "App Preferences",
              children: [
                CustomListTile(
                  title: "Theme",
                  icon: const Icon(Icons.brightness_medium_outlined), // Icon representing theme
                  callback: () {
                    BlocProvider.of<ThemeCubits>(context).toggletheme();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20), // Spacing between sections

            // Section for Account Management
            _buildSettingsSection(
              context,
              title: "Account",
              children: [
                CustomListTile(
                  title: "Create Account",
                  icon: const Icon(Icons.account_circle_outlined),
                  callback: () {
                    Boxes.getprofiledata().clear(); // Clear existing profile data
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilesScreens()));
                  },
                ),
                CustomListTile(
                  title: "Delete Account",
                  icon: const Icon(Icons.delete_outline),
                  callback: () {
                    _showDeleteAccountConfirmation(context);
                  },
                ),
                CustomListTile(
                  title: "Logout",
                  icon: const Icon(Icons.logout),
                  callback: () {
                    _showLogoutConfirmation(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future totaldaysdailog(String totaldays){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: UiHelpers.Customtext(text: "Your Total Days",
                fontsuze: 20,
                fontfamily: "bold",
                context: context),
            content: UiHelpers.Customtext(text: totaldays,
                fontsuze: 14, context: context),
            actions: [
              UiHelpers.Customtextbutton(buttonname: "Ok",
                  callback: (){
                Navigator.pop(context);
                  })
            ],
          );

        });
  }

  // Helper method to build settings sections
  Widget _buildSettingsSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7), // Subtler color for section titles
            ),
          ),
        ),
        Card(
          color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white10
          : AppColors.scaffoldlightmode,
          elevation: 4, // Added elevation to the card
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  // Confirmation dialog for clearing all data
  void _showClearAllDataConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Clear All Data?"),
          content: const Text("Are you sure you want to clear all your personal mood data? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Boxes.userdata().clear(); 
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("All data has been cleared")),
                );
              },
              child: const Text("Clear", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Confirmation dialog for deleting account
  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Account?"),
          content: const Text("Are you sure you want to delete your account? This will clear all your profile and mood data."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Boxes.getprofiledata().clear();
                Boxes.userdata().clear();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Your account has been deleted")),
                );
                // Optionally navigate to a login/onboarding screen after deletion
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilesScreens()));
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Confirmation dialog for logout
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log Out?"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Boxes.getprofiledata().clear();
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfilesScreens()));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged out successfully")),
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.callback,
  });

  final String title;
  final Icon icon;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Increased padding
        child: Row(
          children: [
            Icon(
              icon.icon,
              color: Theme.of(context).iconTheme.color, // Use theme's icon color
            ),
            const SizedBox(width: 16), // Increased spacing between icon and text
            Expanded( // Ensures text takes available space
              child: UiHelpers.Customtext(
                text: title,
                fontsuze: 17, // Slightly adjusted font size
                context: context,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios, // Standard forward arrow icon
              size: 16, // Smaller arrow size
              color: Theme.of(context).iconTheme.color?.withOpacity(0.6), // Subtler color for arrow
            ),
          ],
        ),
      ),
    );
  }
}












//
//
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:personal_mode_app/boxes/profilebox.dart';
// import 'package:personal_mode_app/custom_widget/uihelpers.dart';
// import 'package:personal_mode_app/domain/cubits/theme_cubits.dart';
// import 'package:personal_mode_app/repository/screens/home_screens/drawer_screens.dart';
// import 'package:personal_mode_app/repository/screens/profile_screens/profiles_screens.dart';
// import 'package:personal_mode_app/repository/screens/settingscreens/alldata_screens.dart';
//
// class Settingscreens extends StatefulWidget {
//   const Settingscreens({super.key});
//
//   @override
//   State<Settingscreens> createState() => _SettingscreensState();
// }
//
// class _SettingscreensState extends State<Settingscreens> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: UiHelpers.Customtext(text: "Setting",
//             fontsuze: 20,
//             fontfamily: "bold",
//             context: context),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             SizedBox(height: 20,),
//             CustomListtiel(
//                 title: "Total Days",
//                 icon: Icon(Icons.all_inbox),
//                 callback: (){}
//             ),
//             CustomListtiel(
//                 title: "Clear all data",
//                 icon: Icon(CupertinoIcons.clear_circled),
//                 callback: (){}
//             ),
//             CustomListtiel(
//                 title: "Day dates list",
//                 icon: Icon(Icons.list),
//                 callback: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context)=>AllDataScreen()));
//                 }
//             ),
//             CustomListtiel(
//                 title: "Theme change",
//                 icon: Icon(CupertinoIcons.triangle_lefthalf_fill),
//                 callback: (){
//                   BlocProvider.of<ThemeCubits>(context).toggletheme();
//                 }
//             ),
//             CustomListtiel(
//                 title: "Delete Account",
//                 icon: Icon(Icons.delete),
//                 callback: (){
//                   Boxes.getprofiledata().clear();
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your Account has been deleted")));
//                 }
//             ),
//             CustomListtiel(
//                 title: "Create Account",
//                 icon: Icon(Icons.account_circle),
//                 callback: (){
//                   Boxes.getprofiledata().clear();
//                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfilesScreens()));
//                 }
//             ),
//             CustomListtiel(
//                 title: "Logout",
//                 icon: Icon(Icons.logout),
//                 callback: (){}
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
