import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music/helper/colors.dart';
import 'package:music/screens/album.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List> SongList() async {
    final collectionlist = ["UsersSongs", "songs", "userPodcast", "users"];

    final collections = [];
    for (var element in collectionlist) {
      collections.add(FirebaseFirestore.instance.collection(element));
    }

    final mylist = [];

    for (var collection in collections) {
      final snapshot = await collection.get();
      for (var doc in snapshot.docs) {
        final songName = doc.get("song_name").toString().trim();
        mylist.add({"songname": songName, "data": doc.data()});
      }
    }

    return mylist;
  }

  Future getSearchResult(String s) async {
    final songlist = await SongList();
    print("song list length :${songlist.length}");
    final mylist = [];
    for (var element in songlist) {
      if (element["songname"]
          .toString()
          .toLowerCase()
          .contains(s.toLowerCase())) {
        mylist.add(element);
      }
    }
    return mylist;
  }

  final searchController = TextEditingController();

  var queryREsult;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whitealpha,
      body: SafeArea(
        child: SizedBox(
          height: h,
          width: w,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 55,
                  width: w * 0.85,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.deepOrange),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Container(
                      height: 50,
                      width: w * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
                        controller: searchController,
                        decoration: const InputDecoration(
                            hintText: "Search here",
                            hintStyle: TextStyle(fontSize: 18)),
                        onChanged: (val) async {
                          var res = await getSearchResult(val);
                          setState(() {
                            queryREsult = res;
                          });
                          print("onchanges length : ${res.length}");
                        },
                        onFieldSubmitted: (val) async {
                          var res = await getSearchResult(val);
                          setState(() {
                            queryREsult = res;
                          });
                          print("onsubmit length : ${res.length}");
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                queryREsult != null
                    ? Expanded(
                        child: ListView.builder(
                        itemCount: queryREsult!.length,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, ind) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlbumPage(
                                          song: queryREsult[ind]["data"]))),
                              child: Container(
                                height: 30,
                                width: w - 50,
                                decoration: BoxDecoration(
                                    color: Colors.grey[400]!.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                  child: Text(
                                    "${queryREsult[ind]["songname"]}",
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ))
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
