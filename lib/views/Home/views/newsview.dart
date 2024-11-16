import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsapp/models/newsmodel.dart';
import 'package:newsapp/views/Welcome/onboarding.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/colors.dart';

class newsview extends StatefulWidget {
  const newsview({
    super.key,
  });
  @override
  State<newsview> createState() => newsviewState();
}

class newsviewState extends State<newsview> {
  newsviewState({
    Key? key,
  });

  Timer? debouncer;
  String donationquery = '';
  List<newsmodel> donationschedule = [];

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _donorRegisteredFuture = findNews("");
  }

  Future<List<newsmodel>> findNews(String query) async {
    var response = await http.get(
      Uri.parse("https://saurav.tech/NewsAPI/everything/fox-news.json"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> articlesJson = json.decode(response.body)['articles'];

      // Map each JSON article to a NewsModel and filter by query
      return articlesJson.map((json) => newsmodel.fromJson(json)).where((news) {
        final titleLower = news.title.toLowerCase();
        final authorLower = news.author.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            authorLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception('Failed to load donors');
    }
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  bool search = false;
  final TextEditingController searchcontroller = TextEditingController();

  Future searchBook(String donationquery) async => debounce(() async {
        final donationschedule = await findNews("");

        if (!mounted) return;

        setState(() {
          this.donationquery = donationquery;
          this.donationschedule = donationschedule.cast<newsmodel>();
        });
      });

  late Future<List<newsmodel>> _donorRegisteredFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF09437b),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => WelcomeScreen()));
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: kWhiteColor,
          ),
        ),
        elevation: 0,
        title: Text('MAGA News',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: 14, color: Colors.white)),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 13),
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _donorRegisteredFuture = findNews(value);
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: const BorderSide(
                              color: Color(0x19A2A1A8),
                              width: 1.0,
                            )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: const BorderSide(
                              color: Color(0x19A2A1A8),
                              width: 1.0,
                            )),
                        prefixIcon: const Icon(
                          Icons.search_sharp,
                          size: 20,
                          color: kGreyColor,
                        ),
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                            color: kGreyColor,
                            fontFamily: 'Montserrat',
                            fontSize: 13)),
                  ),
                  Expanded(
                    child: FutureBuilder<List<newsmodel>>(
                      future: _donorRegisteredFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Montserrat',
                                  )));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No news found',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Montserrat',
                                  )));
                        } else {
                          return ScrollConfiguration(
                            behavior: NoGlowBehaviour(),
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          var facebookUrl =
                                              snapshot.data![index].url.toString();
                                          try {
                                            launch(facebookUrl);
                                          } catch (e) {
                                            //To handle error and display error message
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Could Not Launch Link',
                                                  style:
                                                      GoogleFonts.montserrat()),
                                              backgroundColor: Colors.red,
                                              behavior: SnackBarBehavior.fixed,
                                              duration: const Duration(seconds: 4),
                                            ));
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                .0, 5.0, 5.0, 5.0),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.w),
                                              child: Container(
                                                padding: EdgeInsets.all(10.r),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color:
                                                      Colors.blueGrey.shade50,
                                                  // border: Border.all(
                                                  //     width: 0.5,
                                                  //     color: Color(0xFF09437b)),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Image.network(
                                                          snapshot.data![index]
                                                              .urlToImage
                                                              .toString(),
                                                          height: 250,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        const Divider(
                                                            color:
                                                                kPrimaryColor),
                                                        5.verticalSpace,
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Title',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts
                                                                        .montserrat(
                                                                      fontSize:
                                                                          12.sp,
                                                                      color: const Color(
                                                                          0xFF09437b),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5.h,
                                                                  ),
                                                                  Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .blue
                                                                            .shade50,
                                                                        borderRadius:
                                                                            BorderRadius.circular(0)),
                                                                    child: Text(
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .title
                                                                          .toString(),
                                                                      style:
                                                                          const TextStyle(
                                                                        overflow:
                                                                            TextOverflow.clip, // Show "..." for overflow
                                                                        fontSize:
                                                                            14,
                                                                        color:
                                                                            kPrimaryColor,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      // Set max lines if needed
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        10.verticalSpace,
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Title',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts
                                                                        .montserrat(
                                                                      fontSize:
                                                                          12.sp,
                                                                      color: const Color(
                                                                          0xFF09437b),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5.h,
                                                                  ),
                                                                  Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .blue
                                                                            .shade50,
                                                                        borderRadius:
                                                                            BorderRadius.circular(0)),
                                                                    child: Text(
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .author
                                                                          .toString(),
                                                                      style:
                                                                          const TextStyle(
                                                                        overflow:
                                                                            TextOverflow.clip, // Show "..." for overflow
                                                                        fontSize:
                                                                            14,
                                                                        color:
                                                                            kPrimaryColor,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      // Set max lines if needed
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        10.verticalSpace,
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Description',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts
                                                                        .montserrat(
                                                                      fontSize:
                                                                          12.sp,
                                                                      color: const Color(
                                                                          0xFF09437b),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5.h,
                                                                  ),
                                                                  Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .blue
                                                                            .shade50,
                                                                        borderRadius:
                                                                            BorderRadius.circular(0)),
                                                                    child: Text(
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .description
                                                                          .toString(),
                                                                      style:
                                                                          const TextStyle(
                                                                        overflow:
                                                                            TextOverflow.clip, // Show "..." for overflow
                                                                        fontSize:
                                                                            14,
                                                                        color:
                                                                            kPrimaryColor,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      // Set max lines if needed
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    10.verticalSpace,
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('Published At',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts.montserrat(
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: const Color(
                                                                        0xFF09437b))),
                                                            SizedBox(
                                                              height: 5.h,
                                                            ),
                                                            Container(
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          10),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .amber
                                                                      .shade50,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              0)),
                                                              child: Text(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .publishedAt
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    10.verticalSpace,
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: TextButton(
                                                            style: TextButton
                                                                .styleFrom(
                                                              foregroundColor:
                                                                  Colors.black,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                              var facebookUrl =
                                                                  snapshot.data![index].url.toString();
                                                              try {
                                                                launch(
                                                                    facebookUrl);
                                                              } catch (e) {
                                                                //To handle error and display error message
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                      'Could Not Launch Link',
                                                                      style: GoogleFonts
                                                                          .montserrat()),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .fixed,
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              4),
                                                                ));
                                                              }
                                                            },
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .short_text,
                                                                  color: Color(
                                                                      0xFF09437b),
                                                                ),
                                                                SizedBox(
                                                                    width: 5.h),
                                                                Text(
                                                                    'View News Content',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts
                                                                        .montserrat(
                                                                      fontSize:
                                                                          12.sp,
                                                                      color: Color(
                                                                          0xFF09437b),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  );
                                }),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              // Positioned(
              //   bottom: 24.0,
              //   right: 0.0,
              //   child: Column(
              //     children: [
              //       TextButton(
              //         child: Row(children: [
              //           FaIcon(
              //             FontAwesomeIcons.chartSimple,
              //             size: 20,
              //           ),
              //         ]),
              //         style: TextButton.styleFrom(
              //           foregroundColor: Colors.white,
              //           backgroundColor: Color(0xFF09437b),
              //           shape: const RoundedRectangleBorder(
              //               borderRadius: BorderRadius.all(Radius.circular(5))),
              //         ),
              //         onPressed: () async {
              //           Navigator.of(context).push(MaterialPageRoute(
              //               builder: (context) => hschecklist()));
              //         },
              //       ),
              //       TextButton(
              //         child: FaIcon(
              //           FontAwesomeIcons.circlePlus,
              //           size: 20,
              //         ),
              //         style: TextButton.styleFrom(
              //           foregroundColor: Colors.white,
              //           backgroundColor: Color(0xFF09437b),
              //           shape: const RoundedRectangleBorder(
              //               borderRadius: BorderRadius.all(Radius.circular(5))),
              //         ),
              //         onPressed: () async {
              //           Navigator.of(context).push(MaterialPageRoute(
              //               builder: (context) => addsupply()));
              //         },
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
