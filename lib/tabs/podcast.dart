import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music/screens/album.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({super.key});

  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  Future<List> getPodcast() async {
    List podcast = [];
    final fireStoreDB = FirebaseFirestore.instance;

    final ref = await fireStoreDB.collection("songs").get();

    for (var doc in ref.docs) {
      if (doc.get("category").toString().toLowerCase().trim() == "podcast") {
        podcast.add(doc.data());
      }
    }

    // print(popSongs);
    return podcast;
  }

  Future<List> getUserPodcast() async {
    List podcast = [];
    final fireStoreDB = FirebaseFirestore.instance;
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final ref = fireStoreDB.collection("userPodcast");
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              "Recently Released Podcast",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            SizedBox(
              height: 15,
            ),
            FutureBuilder(
              future: getUserPodcast(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    height: h * 0.26,
                    width: w,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, ind) {
                          return Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlbumPage(
                                          song: snapshot.data![ind]))),
                              child: Container(
                                height: h * 0.25,
                                width: w - 130,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: h * 0.2,
                                      width: w - 70,
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
                                          fontSize: snapshot.data![ind]
                                                          ["song_name"]
                                                      .toString()
                                                      .length >
                                                  20
                                              ? 14
                                              : 18,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      snapshot.data![ind]["artist_name"],
                                      style: TextStyle(
                                          fontSize: snapshot.data![ind]
                                                          ["song_name"]
                                                      .toString()
                                                      .length >
                                                  20
                                              ? 14
                                              : 18,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Recommended",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            SizedBox(
              height: 15,
            ),
            FutureBuilder(
              future: getPodcast(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    height: h * 0.26,
                    width: w,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, ind) {
                          return Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlbumPage(
                                          song: snapshot.data![ind]))),
                              child: Container(
                                height: h * 0.25,
                                width: w - 130,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: h * 0.2,
                                      width: w - 70,
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
                                          fontSize: snapshot.data![ind]
                                                          ["song_name"]
                                                      .toString()
                                                      .length >
                                                  20
                                              ? 12
                                              : 18,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      snapshot.data![ind]["artist_name"],
                                      style: TextStyle(
                                          fontSize: snapshot.data![ind]
                                                          ["artist_name"]
                                                      .toString()
                                                      .length >
                                                  20
                                              ? 12
                                              : 18,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
