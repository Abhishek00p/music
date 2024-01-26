import 'package:flutter/material.dart';
import 'package:music/backend/login.dart';
import 'package:music/helper/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';

import '../backend/database.dart';
import '../screens/album.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Future<List> getMusic() async {
    final fireStoreDB = FirebaseFirestore.instance;
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final ref = fireStoreDB.collection("users").doc(userID).collection("Music");
    final refdata = await ref.get().then((value) => value.docs);

    // print(popSongs);
    return refdata.toList();
  }

  Future<List> getPodcast() async {
    final fireStoreDB = FirebaseFirestore.instance;
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final ref =
        fireStoreDB.collection("users").doc(userID).collection("Podcast");
    final refdata = await ref.get().then((value) => value.docs);

    // print(popSongs);
    return refdata.toList();
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Library ",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        )),
                    Row(
                      children: [
                        const Text(
                          "Log out",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        IconButton(
                            onPressed: () async {
                              await signOut();
                              await signOutGoogle();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                            icon: const Icon(
                              Icons.logout,
                              size: 25,
                              color: Colors.white,
                            )),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Your Musics",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: h * 0.22,
                  width: w,
                  child: FutureBuilder(
                    future: getMusic(),
                    builder: (context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data!.isEmpty) {
                          return const SizedBox(
                            height: 80,
                            width: 250,
                            child: Center(
                              child: Text(
                                "No Music found , upload your voice by going to Post Page",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, ind) {
                            final docref = snapshot.data![ind].id;

                            return Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AlbumPage(
                                              song: snapshot.data![ind]))),
                                  child: SizedBox(
                                    height: h * 0.22,
                                    width: w * 0.45,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height: h * 0.13,
                                          width: w * 0.45,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.network(
                                              snapshot.data![ind]["image_url"],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data![ind]["song_name"],
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  await removeSongFromLibrary(
                                                      docref);
                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 25,
                                                  color: Colors.white,
                                                ))
                                          ],
                                        ),
                                        Text(
                                          snapshot.data![ind]["artist_name"],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                        );
                      } else {
                        return const SizedBox(
                          height: 80,
                          width: 250,
                          child: Center(
                            child: Text(
                              "No Music found , upload your voice by going to Post Page",
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Your Podcasts",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: h * 0.33,
                  width: w,
                  child: FutureBuilder(
                    future: getPodcast(),
                    builder: (context, AsyncSnapshot<List> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data!.isEmpty) {
                          return const SizedBox(
                            height: 80,
                            width: 250,
                            child: Center(
                              child: Text(
                                "No Podcast found , upload your voice by going to Post Page",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, ind) {
                            final docref = snapshot.data![ind].id;

                            return Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AlbumPage(
                                            song: snapshot.data![ind]))),
                                child: SizedBox(
                                  height: h * 0.30,
                                  width: w * 0.6,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: h * 0.2,
                                        width: w * 0.6,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            snapshot.data![ind]["image_url"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data![ind]["song_name"],
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                          IconButton(
                                              onPressed: () async {
                                                await removePodcastFromLibrary(
                                                    docref);
                                                setState(() {});
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                size: 25,
                                                color: Colors.white,
                                              ))
                                        ],
                                      ),
                                      Text(
                                        snapshot.data![ind]["artist_name"],
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const SizedBox(
                          height: 80,
                          width: 250,
                          child: Center(
                            child: Text(
                              "No Podcast found , upload your voice by going to Post Page",
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

removeSongFromLibrary(docid) async {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  final docref = FirebaseFirestore.instance.collection("UsersSongs").doc(docid);
  await docref.delete();

  final docrf = FirebaseFirestore.instance
      .collection("users")
      .doc(userID)
      .collection("Music")
      .doc(docid);
  await docrf.delete();

  Toast.show("Removed from Music library",
      duration: 2,
      textStyle: const TextStyle(color: Colors.deepPurple),
      backgroundColor: Colors.white);
}

removePodcastFromLibrary(docid) async {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  final docref =
      FirebaseFirestore.instance.collection("userPodcast").doc(docid);
  await docref.delete();

  final docrf = FirebaseFirestore.instance
      .collection("users")
      .doc(userID)
      .collection("Podcast")
      .doc(docid);
  await docrf.delete();

  Toast.show("Removed from Podcast library",
      duration: 2,
      textStyle: const TextStyle(color: Colors.deepPurple),
      backgroundColor: Colors.white);
}
