import 'package:flutter/material.dart';
import 'package:music/helper/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class LibraryPage extends StatefulWidget {
  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Future<List> getMusic() async {
    List music = [];
    final fireStoreDB = FirebaseFirestore.instance;
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final ref = fireStoreDB.collection("users").doc(userID).collection("Music");
    final refdata = await ref.get().then((value) => value.docs);
    for (var element in refdata) {
      music.add(element.data());
    }
    // print(popSongs);
    return music;
  }

  Future<List> getPodcast() async {
    List podcast = [];
    final fireStoreDB = FirebaseFirestore.instance;
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final ref =
        fireStoreDB.collection("users").doc(userID).collection("Podcast");
    final refdata = await ref.get().then((value) => value.docs);
    for (var element in refdata) {
      podcast.add(element.data());
    }
    // print(popSongs);
    return podcast;
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
        height: h,
        width: w,
        color: whitealpha,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Your Musics",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: h * 0.2,
                width: w,
                child: FutureBuilder(
                  future: getMusic(),
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, ind) {
                          return Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Container(
                              height: h * 0.2,
                              width: w * 0.35,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: h * 0.13,
                                    width: w * 0.34,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        snapshot.data![ind]["image_url"],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    snapshot.data![ind]["song_name"],
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  Text(
                                    snapshot.data![ind]["artist_name"],
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "Your Podcasts",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: h * 0.2,
                width: w,
                child: FutureBuilder(
                  future: getPodcast(),
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, ind) {
                          return Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Container(
                              height: h * 0.17,
                              width: w * 0.35,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: h * 0.12,
                                    width: w * 0.34,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        snapshot.data![ind]["image_url"],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    snapshot.data![ind]["song_name"],
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  Text(
                                    snapshot.data![ind]["artist_name"],
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}
