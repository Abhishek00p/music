import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/helper/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:music/navtabs/fav.dart';
import 'package:music/helper/tabs.dart';
import 'package:music/screens/playlist.dart';
import 'package:toast/toast.dart';

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

  final fireStoreDB = FirebaseFirestore.instance;

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

  getUserSongs() async {
    List songs = [];
    final ref = fireStoreDB.collection("UsersSongs");
    final refdata = await ref.get().then((value) => value.docs);
    for (var element in refdata) {
      songs.add(element.data());
    }
    // print(popSongs.length);
    return songs;
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
        if (element.get("category").toString().toLowerCase().trim() !=
                "mashup" &&
            element.get("category").toString().toLowerCase().trim() !=
                "podcast" &&
            element.get("category").toString().toLowerCase().trim() !=
                "bhajan") {
          mylist.add(element.data());
        }
      } else {
        if (element.get("category").toString().trim() != "mashup" &&
            element.get("category").toString().toLowerCase().trim() !=
                "podcast" &&
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

  getBhajans() async {
    List bhajans = [];
    final ref = fireStoreDB.collection("songs");
    final refdata = await ref.get().then((value) => value.docs);
    for (var element in refdata) {
      if (element.get("category").toString().contains("bhajan")) {
        bhajans.add(element.data());
      }
    }
    // print(popSongs.length);
    return bhajans;
  }

  final nameAndImage = [
    {"name": "asha", "image": "assets/artist/asha.jpg"},
    {"name": "kumar", "image": "assets/artist/kumarsanu.jfif"},
    {"name": "arijit", "image": "assets/artist/arjit.jfif"},
    {"name": "k.k", "image": "assets/artist/kk.jfif"},
    {"name": "dhvani", "image": "assets/artist/dhvani.jfif"},
    {"name": "sonu", "image": "assets/artist/arjit.jfif"},
    {"name": "king", "image": "assets/artist/king.jfif"},
    {"name": "honey", "image": "assets/artist/honeysingh.jfif"},
    {"name": "kishor", "image": "assets/artist/kishor.jfif"},
    {"name": "shreya", "image": "assets/artist/shreya.jfif"},
    {"name": "rafi", "image": "assets/artist/rafi.jfif"},
    {"name": "badshah", "image": "assets/artist/badshah.jfif"},
    {"name": "darshan", "image": "assets/artist/darshan.jfif"},
    {"name": "sidhu", "image": "assets/artist/sidhu.jfif"},
    {"name": "jubin", "image": "assets/artist/jubin.jfif"},
  ];

  String getImage(index) {
    for (Map<String, String> ele in nameAndImage) {
      if (artistNames[index]
          .toString()
          .toLowerCase()
          .contains(ele["name"].toString().toLowerCase())) {
        return ele["image"]!;
      } else {}
    }
    return "assets/play.png";
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    ToastContext().init(context);

    return SingleChildScrollView(
      child: Container(
        height: h * 0.8,
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
                      return BuildList(res: res);
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
              "Recommanded",
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
                      artistNames.shuffle();
                      var nameList = [];
                      for (int i = 0; i < 3; i++) {
                        nameList.add(artistNames[i]);
                      }
                      var resList = [];
                      for (int i = 0; i < nameList.length; i++) {
                        resList.add(res[nameList[i]]);
                      }
                      var songlist = [];
                      for (var i = 0; i < resList.length; i++) {
                        for (var j = 0; j < 3; j++) {
                          songlist.add(resList[i][j]);
                        }
                      }
                      print("  res : ${res[artistNames[2]]}");
                      // return Container();
                      songlist.shuffle();
                      return BuildList(res: songlist);
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
                      return BuildList(res: res);
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
              "Recently Added",
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
                  future: getUserSongs(),
                  builder: (context, AsyncSnapshot<dynamic> data) {
                    if (data.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (data.connectionState == ConnectionState.done) {
                      final res = data.data;
                      return BuildList(res: res);
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

                          final artistImage = getImage(index);

                          return Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () async {
                                print(
                                    "going to playlist : Res = ${res[artistNames[index]]}");

                                Get.to(() => PlayListPlayer(
                                      res: res[artistNames[index]],
                                      ArtistName: artistNames[index],
                                      ArtistImage: artistImage,
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
                                          artistImage,
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
              "Bhajans",
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
                  future: getBhajans(),
                  builder: (context, AsyncSnapshot<dynamic> data) {
                    if (data.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (data.connectionState == ConnectionState.done) {
                      final res = data.data;
                      return BuildList(res: res);
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
                      return BuildList(res: res);
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

            SizedBox(
              height: 75,
            ),
          ]),
        ),
      ),
    );
  }
}
