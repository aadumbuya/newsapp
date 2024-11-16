import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:newsapp/views/Home/views/newsview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var subscription;
  String status = "Offline";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(// <-- STACK AS THE SCAFFOLD PARENT
        children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/newspulse.jpg"), // <-- BACKGROUND IMAGE
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            kPrimaryColor.withOpacity(0.05),
            Colors.white.withOpacity(1)
          ],
          stops: const [0.1, 0.35, 0.8],
        )),
      ),
      Scaffold(
        backgroundColor: Colors.transparent, // <-- SCAFFOLD WITH TRANSPARENT BG
        appBar: AppBar(
          backgroundColor: Colors.transparent, // <-- APPBAR WITH TRANSPARENT BG
          elevation: 0, // <-- ELEVATION ZEROED
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [],
              ),
              10.verticalSpace,
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Welcome to MAGA News",
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              letterSpacing: 0,
                              height: 1.3,
                              overflow: TextOverflow.clip,
                              color: kPrimaryColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  5.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Deep dive into political news, from government policy changes to international relations. Follow the latest from major political events and analyses.",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.sp,
                                letterSpacing: 0,
                                overflow: TextOverflow.clip,
                                fontWeight: FontWeight.w500,
                                color: kPrimaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => newsview()),
                              (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            backgroundColor: kPrimaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                        child: Text(
                          'Continue to News Pulse'.toUpperCase(),
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  20.verticalSpace,
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

Future<bool> getInternetUsingInternetConnectivity() async {
  bool result = await InternetConnectionChecker().hasConnection;
  return result;
}
