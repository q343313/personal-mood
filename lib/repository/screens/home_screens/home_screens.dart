

import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:personal_mode_app/boxes/profilebox.dart';
import 'package:personal_mode_app/custom_widget/customwidgets.dart';
import 'package:personal_mode_app/custom_widget/uihelpers.dart';
import 'package:personal_mode_app/domain/constants/app_colors.dart';
import 'package:personal_mode_app/models/datamodel/userdatamodel.dart';
import 'package:personal_mode_app/proviers/dataproviders.dart';
import 'package:personal_mode_app/proviers/image_provider.dart';
import 'package:personal_mode_app/repository/screens/home_screens/detail_screens.dart';
import 'package:personal_mode_app/repository/screens/home_screens/drawer_screens.dart';
import 'package:personal_mode_app/repository/screens/profile_screens/profiles_screens.dart';
import 'package:provider/provider.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final TextEditingController daytitlecontroller = TextEditingController();
  final TextEditingController bestpointscontroller = TextEditingController();
  final TextEditingController desipointscontroller = TextEditingController();
  final TextEditingController opinioncontroller = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    // Triggers notification every 2 minutes
    Timer.periodic(const Duration(seconds: 120), (_) => triggleNotification());
  }

  void triggleNotification() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: "basic_channel",
        title: "Personal Mood App",
        body: "Hi! Your time is over! Add your today's journey in Personal Mood App!",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProviders>(
      builder: (context, items, child) => Scaffold(
        drawer: const DrawerScreens(),
        appBar: AppBar(
          title: UiHelpers.Customtext(
            text: "Personal Mood",
            fontsuze: 23,
            fontfamily: "bold",
            context: context,
          ),
          actions: [
            IconButton(
              onPressed: () {
                triggleNotification();
              },
              icon: const Icon(Icons.notifications_active_outlined),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            const CustomCard(),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Boxes.userdata().listenable(),
                builder: (context, Box box, _) {
                  var data = box.values.toList().cast<DataModel>();
                  if (data.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 98.0),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage("assets/images/mood2.png"),
                              radius: 120,
                            ),
                            const SizedBox(height: 20),
                            UiHelpers.Customtext(
                              text: "Add Your Day's Mood",
                              fontsuze: 20,
                              fontfamily: "bold",
                              context: context,
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return ReusableCard(
                          title: data[index].daytitle.toString(),
                          image: data[index].image.toString(),
                          datatime: "${data[index].dateTime.day}/${data[index].dateTime.month}/${data[index].dateTime.year}",
                          subtitle: data[index].youropiniononday.toString(),
                          listtilecallback: () {
                            items.adduserdata(
                              data[index].daytitle.toString(),
                              data[index].youropiniononday.toString(),
                              data[index].bestpoints.toString(),
                              data[index].desipoints.toString(),
                              data[index].image.toString(),
                              "${data[index].dateTime.day}/${data[index].dateTime.month}/${data[index].dateTime.year}",
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const DetailScreens()),
                            );
                          },
                          editcallback: () {
                            _editDialog(
                              data[index],
                              data[index].daytitle.toString(),
                              data[index].bestpoints.toString(),
                              data[index].desipoints.toString(),
                              data[index].youropiniononday.toString(),
                            );
                          },
                          deletecallback: () {
                            _deleteValue(data[index]);
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.buttondarkmode,
          onPressed: () {
            _showUserDataDialog();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _deleteValue(DataModel user) {
    user.delete();
  }

  Future<dynamic> _editDialog(
      DataModel user, String dattitle, String best, String desi, String opin) {
    daytitlecontroller.text = dattitle;
    bestpointscontroller.text = best;
    desipointscontroller.text = desi;
    opinioncontroller.text = opin;
    return showDialog(
      context: context,
      builder: (context) {
        return Consumer<ImageProviders>(
          builder: (context, value, child) => Form(
            key: _formkey,
            child: AlertDialog(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : AppColors.scaffoldlightmode,
              title: UiHelpers.Customtext(
                text: "Edit Your Day Journey",
                fontsuze: 18,
                fontfamily: "bold",
                context: context,
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    UiHelpers.Customtextfield(
                      hinttext: "Day Title with emoji",
                      controller: daytitlecontroller,
                      textinputtype: TextInputType.text,
                      prefficicon: const Icon(Icons.emoji_emotions_outlined),
                      context: context,
                    ),
                    const SizedBox(height: 10),
                    UiHelpers.Customtextfield(
                      height: 120,
                      hinttext: "Best Points of your day",
                      controller: bestpointscontroller,
                      textinputtype: TextInputType.text,
                      prefficicon: const Icon(Icons.emoji_people_outlined),
                      context: context,
                    ),
                    const SizedBox(height: 10),
                    UiHelpers.Customtextfield(
                      height: 120,
                      hinttext: "Desired Points of your day",
                      controller: desipointscontroller,
                      textinputtype: TextInputType.text,
                      prefficicon: const Icon(Icons.emoji_emotions),
                      context: context,
                    ),
                    const SizedBox(height: 10),
                    UiHelpers.Customtextfield(
                      hinttext: "Your Opinion on the day",
                      controller: opinioncontroller,
                      textinputtype: TextInputType.text,
                      prefficicon: const Icon(Icons.offline_pin_rounded),
                      context: context,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              actions: [
                UiHelpers.Customtextbutton(
                  buttonname: "Cancel",
                  callback: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                UiHelpers.Customtextbutton(
                  buttonname: "Update",
                  callback: () {
                    if (_formkey.currentState!.validate()) {
                      user.daytitle = daytitlecontroller.text;
                      user.desipoints = desipointscontroller.text;
                      user.bestpoints = bestpointscontroller.text;
                      user.youropiniononday = opinioncontroller.text;

                      user.save();
                      Navigator.pop(context);

                      desipointscontroller.clear();
                      bestpointscontroller.clear();
                      daytitlecontroller.clear();
                      opinioncontroller.clear();
                      value.image_path = null;
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> _showUserDataDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return Consumer<ImageProviders>(
          builder: (context, value, child) => Form(
            key: _formkey,
            child: AlertDialog(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : AppColors.scaffoldlightmode,
              title: UiHelpers.Customtext(
                text: "Add Your Day Journey",
                fontsuze: 18,
                fontfamily: "bold",
                context: context,
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _optionImage(context, () {
                          value.change_galley();
                          value.upload_image(context);
                          Navigator.pop(context);
                        }, () {
                          value.change_camera();
                          value.upload_image(context);
                          Navigator.pop(context);
                        });
                      },
                      child: value.image_path == null || value.image_path!.path.isEmpty
                          ? const CustomCont()
                          : CustomImage(
                        image: DecorationImage(
                          image: FileImage(File(value.image_path!.path).absolute),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    UiHelpers.Customtextfield(
                      hinttext: "Day Title with emoji",
                      controller: daytitlecontroller,
                      textinputtype: TextInputType.text,
                      prefficicon: const Icon(Icons.emoji_emotions_outlined),
                      context: context,
                    ),
                    const SizedBox(height: 10),
                    UiHelpers.Customtextfield(
                      height: 120,
                      hinttext: "Best Points of your day",
                      controller: bestpointscontroller,
                      textinputtype: TextInputType.text,
                      prefficicon: const Icon(Icons.emoji_people_outlined),
                      context: context,
                    ),
                    const SizedBox(height: 10),
                    UiHelpers.Customtextfield(
                      height: 120,
                      hinttext: "Desired Points of your day",
                      controller: desipointscontroller,
                      textinputtype: TextInputType.text,
                      prefficicon: const Icon(Icons.emoji_emotions),
                      context: context,
                    ),
                    const SizedBox(height: 10),
                    UiHelpers.Customtextfield(
                      hinttext: "Your Opinion on the day",
                      controller: opinioncontroller,
                      textinputtype: TextInputType.text,
                      prefficicon: const Icon(Icons.offline_pin_rounded),
                      context: context,
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () async {
                        DateTime? datepicker = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now(),
                        );
                        if (datepicker != null) {
                          value.change_datetime(datepicker);
                        }
                      },
                      child: CustomDataTime(
                        text: "${value.dateTime.day}/${value.dateTime.month}/${value.dateTime.year}",
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                UiHelpers.Customtextbutton(
                  buttonname: "Cancel",
                  callback: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                UiHelpers.Customtextbutton(
                  buttonname: "Add",
                  callback: () {
                    if (_formkey.currentState!.validate()) {
                      final data = DataModel(
                        daytitle: daytitlecontroller.text,
                        bestpoints: bestpointscontroller.text,
                        desipoints: desipointscontroller.text,
                        dateTime: value.dateTime,
                        image: value.image_path!.path.toString(),
                        youropiniononday: opinioncontroller.text,
                      );

                      final box = Boxes.userdata();
                      box.add(data);
                      data.save();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Data Added Successfully")),
                      );

                      desipointscontroller.clear();
                      bestpointscontroller.clear();
                      daytitlecontroller.clear();
                      opinioncontroller.clear();
                      value.image_path = null;
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Refactored method for image selection options
  void _optionImage(BuildContext context, VoidCallback galleryCallback, VoidCallback cameraCallback) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: galleryCallback,
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: cameraCallback,
              ),
            ],
          ),
        );
      },
    );
  }
}


class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.scaffolddarkmode
          : AppColors.scaffoldlightmode,
      margin: const EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal margin
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Increased padding
        child: Wrap(
          children: [
            UiHelpers.Customtext(
              text: "Add your whole day in one place.\nActivities, expenses, thoughts — your journey.",
              fontsuze: 15, // Slightly increased font size for better readability
              context: context,
              // textAlign: TextAlign.center, // Centered text for better presentation
            )
          ],
        ),
      ),
    );
  }
}

class CustomDataTime extends StatelessWidget {
  CustomDataTime({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370,
      height: 55,
      child: Card(
        elevation: 5, // Reduced elevation for a softer look
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white10
            : AppColors.scaffoldlightmode,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined), // More modern calendar icon
              const SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  fontFamily: "bold",
                  fontSize: 16,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.hintdarkmode
                      : AppColors.hintlightmode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomNewCard extends StatelessWidget {
  CustomNewCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Consistent elevation with CustomDataTime
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.scaffolddarkmode // Dark mode color for contrast
          : Colors.blue.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Slightly rounded corners
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Adjusted padding
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "bold",
            fontSize: 16,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.scaffoldlightmode // Light text on dark background
                : AppColors.scaffoldlightmode, // Or a contrasting dark color if needed
          ),
        ),
      ),
    );
  }
}


class ReusableCard extends StatelessWidget {
  const ReusableCard({
    super.key,
    required this.title,
    required this.image,
    required this.datatime,
    required this.subtitle,
    required this.listtilecallback,
    required this.editcallback,
    required this.deletecallback,
  });

  final String title;
  final String image;
  final String datatime;
  final String subtitle;
  final VoidCallback listtilecallback;
  final VoidCallback editcallback;
  final VoidCallback deletecallback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: listtilecallback,
      child: Card(
        elevation: 8, // Reduced elevation for a cleaner look
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Added consistent margin
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.blue.shade900 // Darker blue for better contrast in dark mode
            : Colors.blue.shade50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // More rounded corners
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Consistent padding
          child: Column(
            children: [
              CustomNewCard(text: datatime),
              const SizedBox(height: 20),
              CircleAvatar(
                backgroundImage: FileImage(File(image)),
                radius: 60, // Slightly reduced radius for better fit
              ),
              const SizedBox(height: 15), // Adjusted spacing
              Card(
                elevation: 4, // Slightly less elevation than parent card
                color: Colors.blue.shade400,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rounded corners
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Added padding
                  title: UiHelpers.Customtext(
                    text: title,
                    fontsuze: 18, // Slightly reduced font size for title
                    fontfamily: "bold",
                    context: context,
                  ),
                  subtitle: UiHelpers.Customtext(
                    text: subtitle,
                    fontsuze: 12,
                    fontfamily: "bold",
                    context: context,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: editcallback,
                        icon: const Icon(Icons.edit, color: Colors.white), // White icons for contrast
                      ),
                      IconButton(
                        onPressed: deletecallback,
                        icon: const Icon(Icons.delete_forever, color: Colors.white), // White icons for contrast
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





//
// import 'dart:async';
// import 'dart:io';
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:personal_mode_app/boxes/profilebox.dart';
// import 'package:personal_mode_app/custom_widget/customwidgets.dart';
// import 'package:personal_mode_app/custom_widget/uihelpers.dart';
// import 'package:personal_mode_app/domain/constants/app_colors.dart';
// import 'package:personal_mode_app/models/datamodel/userdatamodel.dart';
// import 'package:personal_mode_app/proviers/dataproviders.dart';
// import 'package:personal_mode_app/proviers/image_provider.dart';
// import 'package:personal_mode_app/repository/screens/home_screens/detail_screens.dart';
// import 'package:personal_mode_app/repository/screens/home_screens/drawer_screens.dart';
// import 'package:personal_mode_app/repository/screens/profile_screens/profiles_screens.dart';
// import 'package:provider/provider.dart';
//
// class HomeScreens extends StatefulWidget {
//   const HomeScreens({super.key});
//
//   @override
//   State<HomeScreens> createState() => _HomeScreensState();
// }
//
// class _HomeScreensState extends State<HomeScreens> {
//
//   TextEditingController daytitlecontroller=  TextEditingController();
//   TextEditingController bestpointscontroller= TextEditingController();
//   TextEditingController desipointscontroller = TextEditingController();
//   TextEditingController opinioncontroller= TextEditingController();
//
//   final _formkey=  GlobalKey<FormState>();
//
//
//
//   @override
//   void initState() {
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed){
//       if(!isAllowed){
//         AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });
//     // TODO: implement initState
//     super.initState();
//     Timer.periodic(Duration(hours: 24),
//         (_)=>setState(() {
//           trigglenotification();
//         }));
//   }
//
//   trigglenotification(){
//     AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: 10,
//             channelKey: "basic_channel",
//           title: "Personal Mood App",
//           body: "Hi Your time is over!Add your today journey in personal mood app!"
//         )
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<DataProviders>(
//       builder: (context,items,child)=>
//        Scaffold(
//         drawer: DrawerScreens(),
//         appBar: AppBar(
//           title: UiHelpers.Customtext(text: "Personal Mode",
//               fontsuze: 23,
//               fontfamily: "bold",
//               context: context),
//           actions: [
//             IconButton(onPressed: (){
//               trigglenotification();
//             }, icon: Icon(Icons.notification_add))
//           ],
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               SizedBox(height: 20,),
//               CustomCard(),
//
//               SizedBox(height: 20,),
//
//               Expanded(
//                 child: ValueListenableBuilder(
//                     valueListenable: Boxes.userdata().listenable(),
//                     builder: (context,Box box,_){
//                       var data = box.values.toList().cast<DataModel>();
//                       if(data == null || data.isEmpty){
//                         return Center(
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 98.0),
//                             child: Column(
//                               children: [
//                                 CircleAvatar(
//                                 backgroundImage: AssetImage("assets/images/mood2.png"),
//                                 radius: 120,
//                                 ),
//                                 SizedBox(height: 20,),
//                                 UiHelpers.Customtext(text: "Add Your Day Mood",
//                                     fontsuze: 20,
//                                     fontfamily: "bold",
//                                     context: context)
//                               ],
//                             ),
//                           ),
//                         );
//                       }else{
//
//                         return ListView.builder(itemCount: data.length,
//                           itemBuilder: (context,index){
//                             return ReusableCard(
//                               title: data[index].daytitle.toString(),
//                               image: data[index].image.toString(),
//                               datatime:"${data[index].dateTime.day}/${data[index].dateTime.month}/${data[index].dateTime.year}" ,
//                               subtitle: data[index].youropiniononday.toString(),
//                               listtilecallback: (){
//                                 items.adduserdata(
//                                     data[index].daytitle.toString(),
//                                     data[index].youropiniononday.toString(),
//                                     data[index].bestpoints.toString(),
//                                     data[index].desipoints.toString(),
//                                     data[index].image.toString(),
//                                     "${data[index].dateTime.day}/${data[index].dateTime.month}/${data[index].dateTime.year}"
//                                 );
//                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailScreens()));
//                               },
//                               editcallback: (){
//                                 Editdialog(
//                                     data[index],
//                                     data[index].daytitle.toString(),
//                                     data[index].bestpoints.toString(),
//                                     data[index].desipoints.toString(),
//                                     data[index].youropiniononday.toString()
//                                 );
//                               },
//                               deletecallback: (){deletevalue(data[index]);},
//                             );
//
//                           },);
//
//                       }
//
//                     }
//                 ),
//               )
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: AppColors.buttondarkmode,
//           onPressed: (){
//             userdatadialog();
//           },
//         child: Icon(Icons.add),),
//       ),
//     );
//   }
//
//    deletevalue(DataModel user){
//     user.delete();
//   }
//
//   Future Editdialog(DataModel user,String dattitle,best,desi,opin){
//     daytitlecontroller.text = dattitle;
//     bestpointscontroller.text = best;
//     desipointscontroller.text = desi;
//     opinioncontroller.text = opin;
//     return showDialog(
//         context: context,
//         builder: (context){
//           return Consumer<ImageProviders>(
//             builder: (context,value,child)=>
//                 Form(
//                   key: _formkey,
//                   child: AlertDialog(
//                     backgroundColor: Theme.of(context).brightness == Brightness.dark
//                         ? Colors.black
//                         : AppColors.scaffoldlightmode,
//                     title: UiHelpers.Customtext(text: "Add Your Day Journey",
//                         fontsuze: 18,
//                         fontfamily: "bold",
//                         context: context),
//
//                     content: SingleChildScrollView(
//                       child: Column(
//                         children: [
//
//                           SizedBox(height: 20,),
//
//                           UiHelpers.Customtextfield(hinttext: "Day Title with emoji",
//                               controller: daytitlecontroller,
//                               textinputtype: TextInputType.text,
//                               prefficicon: Icon(Icons.emoji_emotions_outlined),
//                               context: context),
//
//                           SizedBox(height: 10,),
//
//                           UiHelpers.Customtextfield(
//                               height: 120,
//                               hinttext: "Best Point of your days",
//                               controller: bestpointscontroller,
//                               textinputtype: TextInputType.text,
//                               prefficicon: Icon(Icons.emoji_people_outlined),
//                               context: context),
//
//                           SizedBox(height: 10,),
//
//                           UiHelpers.Customtextfield(
//                               height: 120,
//                               hinttext: "Desi Point of your days",
//                               controller: desipointscontroller,
//                               textinputtype: TextInputType.text,
//                               prefficicon: Icon(Icons.emoji_emotions),
//                               context: context),
//
//                           SizedBox(height: 10,),
//
//                           UiHelpers.Customtextfield(hinttext: "Your Opinion on day",
//                               controller: opinioncontroller,
//                               textinputtype: TextInputType.text,
//                               prefficicon: Icon(Icons.offline_pin_rounded),
//                               context: context),
//
//                           SizedBox(height: 15,),
//
//                         ],
//                       ),
//                     ),
//
//                     actions: [
//                       UiHelpers.Customtextbutton(buttonname: "Cancel",
//                           callback: (){
//                             Navigator.pop(context);
//                           }),
//                       SizedBox(width: 10,),
//                       UiHelpers.Customtextbutton(buttonname: "Update",
//                           callback: (){
//                             if(_formkey.currentState!.validate()){
//
//                               user.daytitle = daytitlecontroller.text;
//                               user.desipoints  = desipointscontroller.text;
//                               user.bestpoints = bestpointscontroller.text;
//                               user.youropiniononday = opinioncontroller.text;
//
//                               user.save();
//                               Navigator.pop(context);
//
//                               desipointscontroller.clear();
//                               bestpointscontroller.clear();
//                               daytitlecontroller.clear();
//                               opinioncontroller.clear();
//                               value.image_path = null;
//
//                             }
//
//                           }),
//
//                     ],
//                   ),
//                 ),
//           );
//         }
//     );
//   }
//
//   Future userdatadialog(){
//     return showDialog(
//         context: context,
//         builder: (context){
//           return Consumer<ImageProviders>(
//             builder: (context,value,child)=>
//            Form(
//              key: _formkey,
//              child: AlertDialog(
//                 backgroundColor: Theme.of(context).brightness == Brightness.dark
//                 ? Colors.black
//                 : AppColors.scaffoldlightmode,
//                 title: UiHelpers.Customtext(text: "Add Your Day Journey",
//                     fontsuze: 18,
//                     fontfamily: "bold",
//                     context: context),
//
//                 content: SingleChildScrollView(
//                   child: Column(
//                     children: [
//
//                       InkWell(
//                         onTap: (){optionimage(context, (){
//                           value.change_galley();
//                           value.upload_image(context);
//                           Navigator.pop(context);
//                         }, (){
//                           value.change_camera();
//                           value.upload_image(context);
//                           Navigator.pop(context);
//                         });},
//                         child: value.image_path == null || value.image_path!.path.isEmpty?
//                         CustomCont():CustomImage(image: DecorationImage(
//                             image: FileImage(File(value.image_path!.path).absolute),fit: BoxFit.cover
//                         )),
//                       ),
//
//                       SizedBox(height: 20,),
//
//                       UiHelpers.Customtextfield(hinttext: "Day Title with emoji",
//                           controller: daytitlecontroller,
//                           textinputtype: TextInputType.text,
//                           prefficicon: Icon(Icons.emoji_emotions_outlined),
//                           context: context),
//
//                       SizedBox(height: 10,),
//
//                       UiHelpers.Customtextfield(
//                         height: 120,
//                           hinttext: "Best Point of your days",
//                           controller: bestpointscontroller,
//                           textinputtype: TextInputType.text,
//                           prefficicon: Icon(Icons.emoji_people_outlined),
//                           context: context),
//
//                       SizedBox(height: 10,),
//
//                       UiHelpers.Customtextfield(
//                           height: 120,
//                           hinttext: "Desi Point of your days",
//                           controller: desipointscontroller,
//                           textinputtype: TextInputType.text,
//                           prefficicon: Icon(Icons.emoji_emotions),
//                           context: context),
//
//                       SizedBox(height: 10,),
//
//                       UiHelpers.Customtextfield(hinttext: "Your Opinion on day",
//                           controller: opinioncontroller,
//                           textinputtype: TextInputType.text,
//                           prefficicon: Icon(Icons.offline_pin_rounded),
//                           context: context),
//
//                       SizedBox(height: 15,),
//
//                       InkWell(
//                         onTap: ()async{
//                           DateTime?datepicker = await showDatePicker(
//                               context: context,
//                               firstDate: DateTime(2024),
//                               lastDate: DateTime.now(),
//                           );
//
//                           if(datepicker != null){
//                             value.change_datetime(datepicker);
//                           }
//                         },
//                           child: CustomDataTime(text: "${value.dateTime.day}/${value.dateTime.month}/${value.dateTime.year}"))
//
//                     ],
//                   ),
//                 ),
//
//                 actions: [
//                   UiHelpers.Customtextbutton(buttonname: "Cancel",
//                       callback: (){
//                         Navigator.pop(context);
//                       }),
//                   SizedBox(width: 10,),
//                   UiHelpers.Customtextbutton(buttonname: "Add",
//                       callback: (){
//                     if(_formkey.currentState!.validate()){
//
//                         final data = DataModel(
//                             daytitle: daytitlecontroller.text,
//                             bestpoints: bestpointscontroller.text,
//                             desipoints: desipointscontroller.text,
//                             dateTime: value.dateTime,
//                             image: value.image_path!.path.toString(),
//                             youropiniononday: opinioncontroller.text
//                         );
//
//                         final box = Boxes.userdata();
//
//                         box.add(data);
//                         data.save();
//                         Navigator.pop(context);
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Add Successfully")));
//
//                         desipointscontroller.clear();
//                         bestpointscontroller.clear();
//                         daytitlecontroller.clear();
//                         opinioncontroller.clear();
//                         value.image_path = null;
//
//                       }
//
//                       }),
//
//                 ],
//               ),
//            ),
//           );
//         }
//     );
//   }
// }
//
// class CustomCard extends StatelessWidget {
//   const CustomCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 10,
//       color: Theme.of(context).brightness == Brightness.dark
//       ? AppColors.scaffolddarkmode
//       : AppColors.scaffoldlightmode,
//       child: Padding(padding: EdgeInsets.all(13),
//       child: Wrap(
//         children: [
//           UiHelpers.Customtext(text: "Add your whole day in one place.\nActivities, expenses, thoughts — your journey.",
//               fontsuze: 14,
//               context: context)
//         ],
//       ),),
//     );
//   }
// }
//
// class CustomDataTime extends StatelessWidget {
//    CustomDataTime({super.key,required this.text});
//
//   String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 370,
//       height: 55,
//       child: Card(
//         elevation: 10,
//         color: Theme.of(context).brightness == Brightness.dark
//         ? Colors.white10
//         : AppColors.scaffoldlightmode,
//         child: Padding(padding: EdgeInsets.only(left: 18),
//         child: Row(
//           children: [
//             Icon(Icons.calendar_month_outlined),
//
//             SizedBox(width: 10,),
//
//             Text(text,
//             style: TextStyle(
//               fontFamily: "bold",
//               fontSize: 16,
//               color: Theme.of(context).brightness == Brightness.dark
//                 ? AppColors.hintdarkmode
//                   : AppColors.hintlightmode
//             ),)
//           ],
//         ),),
//       ),
//     );
//   }
// }
//
// class CustomNewCard extends StatelessWidget {
//   CustomNewCard({super.key,required this.text});
//
//   String text;
//
//   @override
//   Widget build(BuildContext context) {
//     return  Card(
//         elevation: 10,
//         color: Theme.of(context).brightness == Brightness.dark
//             ? AppColors.scaffolddarkmode
//             : Colors.blue.shade300,
//         child: Padding(padding: EdgeInsets.all(18),
//           child:
//               Text(text,
//                 style: TextStyle(
//                     fontFamily: "bold",
//                     fontSize: 16,
//                     color: Theme.of(context).brightness == Brightness.dark
//                         ? AppColors.scaffoldlightmode
//                         : AppColors.scaffoldlightmode
//                 ),)
//         )
//     );
//   }
// }
//
// class ReusableCard extends StatelessWidget {
//    ReusableCard({super.key,required this.title,required this.image,required this.datatime,required this.subtitle,required this.listtilecallback,required this.editcallback,required this.deletecallback});
//
//   String title;
//   String image;
//   String datatime;
//   String subtitle;
//   VoidCallback listtilecallback;
//   VoidCallback editcallback;
//   VoidCallback deletecallback;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: (){
//         listtilecallback();
//       },
//       child: Card(
//         elevation: 20,
//         color: Theme.of(context).brightness == Brightness.dark
//             ? Colors.blue.shade100
//             :Colors.blue.shade50,
//         child: Padding(padding: EdgeInsets.all(20),
//           child:Center(
//             child: Column(
//               children: [
//                 CustomNewCard(text: datatime),
//                 SizedBox(height: 20,),
//
//                 CircleAvatar(
//                   backgroundImage: FileImage(File(image)),
//                   radius: 80,
//                 ),
//                 SizedBox(height: 10,),
//                 Card(
//                   elevation: 10,
//                   color: Colors.blue.shade400,
//                   child: ListTile(
//
//                     title: UiHelpers.Customtext(text:title,
//                         fontsuze: 20,
//                         fontfamily: "bold",
//                         context: context),
//                     subtitle: UiHelpers.Customtext(text: subtitle,
//                         fontsuze: 12,
//                         fontfamily: "bold",
//                         context: context),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(onPressed: (){editcallback();}, icon: Icon(Icons.edit)),
//                         IconButton(onPressed: (){deletecallback();}, icon: Icon(Icons.delete_forever))
//                       ],
//                     ),
//                   ),
//                 )
//
//               ],
//             ),
//           ),),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
// //   Card(
// //   elevation: 20,
// //   color: Theme.of(context).brightness == Brightness.dark
// //       ? Colors.blue.shade100
// //       :Colors.blue.shade100,
// //   child: Padding(padding: EdgeInsets.all(20),
// //     child:Center(
// //       child: Column(
// //         children: [
// //             CustomNewCard(text: "${data[index].dateTime.day}/${data[index].dateTime.month}/${data[index].dateTime.year}"),
// //           SizedBox(height: 20,),
// //
// //           CircleAvatar(
// //             backgroundImage: FileImage(File(data[index].image.toString())),
// //             radius: 80,
// //           ),
// //           SizedBox(height: 10,),
// //           ListTile(
// //             title: UiHelpers.Customtext(text: data[index].daytitle.toString(),
// //                 fontsuze: 20,
// //                 fontfamily: "bold",
// //                 context: context),
// //             subtitle: UiHelpers.Customtext(text: data[index].youropiniononday.toString(),
// //                 fontsuze: 12,
// //                 fontfamily: "bold",
// //                 context: context),
// //             trailing: Row(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
// //                 IconButton(onPressed: (){}, icon: Icon(Icons.delete_forever))
// //               ],
// //             ),
// //           )
// //
// //         ],
// //       ),
// //     ),),
// // );
//
