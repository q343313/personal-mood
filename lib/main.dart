

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_mode_app/domain/constants/app_themes.dart';
import 'package:personal_mode_app/domain/cubits/theme_cubits.dart';
import 'package:personal_mode_app/domain/cubits/theme_states.dart';
import 'package:personal_mode_app/proviers/dataproviders.dart';
import 'package:personal_mode_app/proviers/image_provider.dart';
import 'package:personal_mode_app/repository/screens/splash_screens/splash1_screens.dart';
import 'package:provider/provider.dart';

import 'models/datamodel/userdatamodel.dart';
import 'models/profile_model/profilemodel.dart';

void main()async{
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: "basic_channel",
            channelName: "Basic notification",
            channelDescription: "Notification channel for basic test"
        ),
      ],
    debug: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  var directry =  await getApplicationDocumentsDirectory();
  Hive.init(directry.path);
  Hive.registerAdapter(ProfileModelAdapter());
  Hive.openBox<ProfileModel>("profiledata");
  Hive.registerAdapter(DataModelAdapter());
  Hive.openBox<DataModel>("userdata");

  runApp(BlocProvider(
    create: (_)=>ThemeCubits(),
      child: DevicePreview(builder:(context)=> MyApp())));
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>ImageProviders()),
        ChangeNotifierProvider(create: (_)=>DataProviders())
      ],
      child: BlocBuilder<ThemeCubits,ThemeStates>(builder: (context,state){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state is LightThemeStates?AppThemes.ligththemedata:AppThemes.darkthemedata,
          title: "Personal Mood App",
          home: Splash1Screens(),

        );
      }),
    );
  }

}