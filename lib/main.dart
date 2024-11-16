import 'package:firebase_core/firebase_core.dart';
import 'package:newsapp/views/Welcome/onboarding.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? id, token, onboarding;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const NewsPulse());
  
}

class NewsPulse extends StatefulWidget {
  const NewsPulse({super.key});

  @override
  State<NewsPulse> createState() => _NewsPulseState();
}

class _NewsPulseState extends State<NewsPulse> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (_, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primaryColor: kPrimaryColor,

          // textTheme:
          //     Typography.englishLike2018.apply(bodyColor: Colors.white),
          scaffoldBackgroundColor: kWhiteColor,
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.black,
              primary: kPrimaryColor,
              outline: Colors.grey,
              surface: kWhiteColor),
        ),
        home: WelcomeScreen(),
      );
    });
  }
}
