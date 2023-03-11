import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music/screens/album.dart';
import 'package:toast/toast.dart';

class FavSongs extends StatefulWidget {
  const FavSongs({super.key});

  @override
  State<FavSongs> createState() => _FavSongsState();
}

class _FavSongsState extends State<FavSongs> {
  Future<List> getReady() async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final firestoreUserDAta = await FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .collection("Fav")
        .get();

    return firestoreUserDAta.docs.toList();
  }

  @override
  void initState() {
    getReady();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
        height: h,
        width: w,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Your Favourite Songs",
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: getReady(),
              builder: (context, AsyncSnapshot<List> snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snap.hasError) {
                  return Container(
                    height: 50,
                    child: Text("Retry in few secs"),
                  );
                } else if (snap.connectionState == ConnectionState.done) {
                  if (snap.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: snap.data!.length,
                        itemBuilder: (context, index) {
                          final docref = snap.data![index].id;
                          return Padding(
                            padding:
                                EdgeInsets.only(bottom: 15, left: 15, right: 5),
                            child: Row(
                              children: [
                                Container(
                                  height: h * 0.1,
                                  width: w * 0.8,
                                  padding: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[600]!.withOpacity(0.2),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(40),
                                          bottomRight: Radius.circular(40))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: h * 0.1,
                                        width: w * 0.25,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                          child: Image.network(
                                            snap.data![index]["image_url"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            snap.data![index]["song_name"]
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            snap.data![index]["artist_name"]
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AlbumPage(
                                                    song: snap.data![index]))),
                                        child: Container(
                                          height: 30,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              color: Colors.blueAccent),
                                          child: Center(
                                            child: Text(
                                              "Play ",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      await removeSongFromFav(docref);

                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.favorite,
                                      size: 22,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                        child: Container(
                      height: 100,
                      width: 200,
                      child: Center(
                        child: Text(
                          "No Fav found , you can add songs to fav by Clicking on Heart Icon",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                    ));
                  }
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ));
  }
}

removeSongFromFav(docID) async {
  final userID = FirebaseAuth.instance.currentUser!.uid;
  final docref = FirebaseFirestore.instance
      .collection("users")
      .doc(userID)
      .collection("Fav")
      .doc(docID);
  await docref.delete();
  Toast.show("REmoved from fav",
      duration: 2,
      textStyle: TextStyle(color: Colors.deepPurple),
      backgroundColor: Colors.white);
}
