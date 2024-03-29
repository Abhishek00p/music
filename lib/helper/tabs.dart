import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/helper/colors.dart';
import '../screens/search.dart';
import '../tabs/podcast.dart';
import '../navtabs/home.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with TickerProviderStateMixin {
  late TabController _tabController;

  late String username;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    username = FirebaseAuth.instance.currentUser!.displayName.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2, // number of tabs
      child: Scaffold(
        backgroundColor: whitealpha,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  width: w - 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 14,
                          child: Center(
                            child: Text(
                              username[0].capitalize!,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        "Discover",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      GestureDetector(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SearchPage()));
                          },
                          child: const Icon(
                            Icons.search,
                            size: 24,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: w,
                child: TabBar(
                  physics: const NeverScrollableScrollPhysics(),
                  indicatorColor: Colors.transparent,
                  tabs: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _tabController.index = 0;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _tabController.index == 0
                                ? Colors.deepOrange
                                : Colors.white.withAlpha(20)),
                        child: const Center(
                          child: Text(
                            "Music",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _tabController.index = 1;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _tabController.index == 1
                                ? Colors.deepOrange
                                : Colors.white.withAlpha(20)),
                        child: const Center(
                          child: Text(
                            "Podcast",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: h * 0.72,
                width: w,
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: const [
                    // Widgets for the first tab
                    Home(),
                    PodcastPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
