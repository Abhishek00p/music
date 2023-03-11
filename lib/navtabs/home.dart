import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/helper/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:music/backend/database.dart';
import 'package:music/navtabs/fav.dart';
import 'package:music/helper/tabs.dart';
import 'package:music/helper/upload.dart';
import 'package:music/screens/playlist.dart';
import 'package:toast/toast.dart';

import '../backend/firebaseDatabase.dart';
import 'libraryNavPage.dart';
import '../helper/listviewBuilder.dart';
import 'postpage.dart';

class NavPages extends StatefulWidget {
  @override
  State<NavPages> createState() => _NavPagesState();
}

class _NavPagesState extends State<NavPages> {
  int navBarIndex = 1;
  List<Widget> pages = [LibraryPage(), MyWidget(), PostNavPage(), FavSongs()];

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: whitealpha,
        body: SafeArea(child: pages[navBarIndex]),
        bottomNavigationBar: DefaultTabController(
          initialIndex: 1,
          length: pages.length,
          child: Container(
            padding: EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.transparent,
            ),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent),
                child: TabBar(
                  indicatorWeight: 3.0,
                  onTap: (value) => setState(() {
                    navBarIndex = value;
                  }),
                  labelColor: Color.fromARGB(255, 255, 255, 255),
                  indicatorColor: Colors.white,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                  unselectedLabelColor: Color.fromARGB(255, 177, 167, 167),
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.library_music,
                        size: 30,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.house,
                        size: 30,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.library_add,
                        size: 30,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.favorite_rounded,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedType = 0;

  final songList = [
    {"Title": "Title", "Artist": "Artist", "image": "assets/arjit.jpg"},
    {"Title": "Title", "Artist": "Artist", "image": "assets/arjit.jpg"},
    {"Title": "Title", "Artist": "Artist", "image": "assets/arjit.jpg"},
  ];
  final imageList = [
    "assets/asha_bosle.jpg",
    "assets/arjit.jpg",
  ];
  var result;
  final fireStoreDB = FirebaseFirestore.instance;

  ready() async {
    final res = await fireStoreDB.collection("songs");
    res.get().then((value) => result = value.docs);
    // print("result : ${result.length}");
  }

  final popSongs = [];
  final oldSongs = [];
  final artist = [];
  final lovesong = [];

  getHipHopSongs() async {
    final ref = fireStoreDB.collection("songs");
    final refdata = await ref.get().then((value) => value.docs);
    for (var element in refdata) {
      if (element.get("category").toString().contains("pop")) {
        popSongs.add(element.data());
      }
    }
    // print(popSongs);
    return popSongs;
  }

  getOldSongs() async {
    final ref = fireStoreDB.collection("songs");
    final refdata = await ref.get().then((value) => value.docs);
    for (var element in refdata) {
      if (element.get("category").toString().contains("old song")) {
        oldSongs.add(element.data());
      }
    }
    // print(popSongs.length);
    return oldSongs;
  }

  getLoveSongs() async {
    final ref = fireStoreDB.collection("songs");
    final refdata = await ref.get().then((value) => value.docs);
    for (var element in refdata) {
      if (element.get("category").toString().contains("love")) {
        lovesong.add(element.data());
      }
    }
    // print(popSongs.length);
    return lovesong;
  }

  final artistNames = [];
  final artistmap = {};
  getAllArtist() async {
    final ref = fireStoreDB.collection("songs");
    final refdata = await ref.get().then((value) => value.docs);
    for (var element in refdata) {
      var val = element.get("artist_name").toString().trim();
      if (artistNames.contains(val)) {
        var mylist = artistmap[val];
        if (element.get("category").toString().trim() != "mashup" &&
            element.get("category").toString().trim() != "bhajan") {
          mylist.add(element.data());
        }
      } else {
        if (element.get("category").toString().trim() != "mashup" &&
            element.get("category").toString().trim() != "bhajan") {
          artistNames.add(val);
          artistmap[val] = [];

          List mylist = artistmap[val];
          mylist.add(element.data());
        }
      }
    }
    // print("artistmap :$artistmap");
    return artistmap;
  }

  @override
  void initState() {
    ready();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        height: h * 0.85,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Carousel
            Container(
              height: h * 0.2,
              width: w - 40,
              child: CarouselSlider(
                items: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: h * 0.19,
                        width: w - 40,
                        child: Image.asset(
                          "assets/adImage.jpg",
                          fit: BoxFit.cover,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: h * 0.19,
                        width: w - 40,
                        child: Image.asset(
                          "assets/adImage2.jpg",
                          fit: BoxFit.cover,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: h * 0.19,
                        width: w - 40,
                        child: Image.asset(
                          "assets/adImage3.jpg",
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
                options: CarouselOptions(
                  height: h * 0.2,
                  aspectRatio: 16 / 9,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayCurve: Curves.linearToEaseOut,
                  scrollPhysics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Text(
              "Hip Hop",
              style: TextStyle(
                  fontSize: 21,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: h * 0.2,
              width: w - 40,
              child: FutureBuilder(
                  future: getHipHopSongs(),
                  builder: (context, AsyncSnapshot<dynamic> data) {
                    if (data.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (data.connectionState == ConnectionState.done) {
                      // print(data.data);
                      final res = data.data;
                      return BuildList(songsList: songList, res: res);
                    } else {
                      Toast.show("Some Error occured while fetching data",
                          duration: 2);
                      return SizedBox();
                    }
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Old Songs",
              style: TextStyle(
                  fontSize: 21,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: h * 0.2,
              width: w - 40,
              child: FutureBuilder(
                  future: getOldSongs(),
                  builder: (context, AsyncSnapshot<dynamic> data) {
                    if (data.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (data.connectionState == ConnectionState.done) {
                      final res = data.data;
                      return BuildList(songsList: songList, res: res);
                    } else {
                      Toast.show("Some Error occured while fetching data",
                          duration: 2);
                      return SizedBox();
                    }
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Top Artist",
              style: TextStyle(
                  fontSize: 21,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: h * 0.2,
              width: w - 40,
              child: FutureBuilder(
                  future: getAllArtist(),
                  builder: (context, AsyncSnapshot<dynamic> data) {
                    if (data.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (data.connectionState == ConnectionState.done) {
                      final res = data.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: artistNames.length,
                        itemBuilder: (context, index) {
                          // print(" playlist : Res = ${res[artistNames[index]]}");
                          return Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () {
                                print(
                                    "going to playlist : Res = ${res[artistNames[index]]}");
                                Get.to(() => PlayListPlayer(
                                      res: res[artistNames[index]],
                                      ArtistName: artistNames[index],
                                    ));
                              },
                              child: Container(
                                height: h * 0.2,
                                width: w * 0.35,
                                child: Column(
                                  children: [
                                    Container(
                                      height: h * 0.16,
                                      width: w * 0.35,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                          "assets/arjit.jpg",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      artistNames[index],
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      Toast.show("Some Error occured while fetching data",
                          duration: 2);
                      return SizedBox();
                    }
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Love Songs",
              style: TextStyle(
                  fontSize: 21,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: h * 0.2,
              width: w - 40,
              child: FutureBuilder(
                  future: getLoveSongs(),
                  builder: (context, AsyncSnapshot<dynamic> data) {
                    if (data.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (data.connectionState == ConnectionState.done) {
                      final res = data.data;
                      return BuildList(songsList: songList, res: res);
                    } else {
                      Toast.show("Some Error occured while fetching data",
                          duration: 2);
                      return SizedBox();
                    }
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            // Text(
            //   "Made for you",
            //   style: TextStyle(
            //       fontSize: 21,
            //       color: Colors.white,
            //       fontWeight: FontWeight.w700),
            // ),
            // SizedBox(
            //   height: 15,
            // ),
            // Container(
            //   height: h * 0.2,
            //   width: w - 40,
            //   child: FutureBuilder(
            //       future: ready(),
            //       builder:
            //           (context, AsyncSnapshot<dynamic> data) {
            //         if (data.connectionState ==
            //             ConnectionState.waiting) {
            //           return Center(
            //             child: CircularProgressIndicator(),
            //           );
            //         } else if (data.connectionState ==
            //             ConnectionState.done) {
            //           final res = data.data;
            //           return BuildList(
            //               songsList: songList, res: result);
            //         } else {
            //           Toast.show(
            //               "Some Error occured while fetching data",
            //               duration: 2);
            //           return SizedBox();
            //         }
            //       }),
            // ),
            SizedBox(
              height: 75,
            ),
          ]),
        ),
      ),
    );
  }
}
