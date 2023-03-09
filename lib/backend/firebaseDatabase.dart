import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class FirebaseDB {
  // storeToRealTimeDB(String artistName) async {
  //   final storageRef = FirebaseStorage.instance
  //       .refFromURL("gs://music-app-84927.appspot.com/allsongs");
  //   int i = 0;
  //   storageRef.listAll().then((result) {
  //     // print("res :${result.prefixes}");
  //     result.prefixes.forEach((itemRef) async {
  //       final stref =
  //           FirebaseStorage.instance.ref("allsongs/She Don't Give A/song");
  //       print("$i:${itemRef.child("song")},   :: ${stref.getData()}");
  //       i++;
  //       // print("url : ${itemRef.getDownloadURL().then((value) => print(value))}");
  //       var url;

  //       // await itemRef.getDownloadURL().then((value) => url = value);
  //       // try {
  //       //   final ref = FirebaseDatabase.instance.ref("asha bosle");
  //       //   var name = itemRef.name.toLowerCase();
  //       //   name = name.replaceAll(".mp3", "");
  //       //   print(name + "--");
  //       //   if (name.isNotEmpty || name != "") {
  //       //     await ref.child(name).set({
  //       //       'name': itemRef.name,
  //       //       'url': url,
  //       //     });
  //       //   } else {
  //       //     await ref.child("name").set({
  //       //       'name': "song",
  //       //       'url': url,
  //       //     });
  //       //   }
  //       // } catch (e) {
  //       //   print(e);
  //       // }
  //     });
  //   }).catchError((error) {
  //     print(error);
  //   });
  // }

  ReadDataFromRealTimeDB(String name) async {
    final ref = FirebaseDatabase.instance
        .refFromURL("https://music-app-84927-default-rtdb.firebaseio.com/");
    var res;
    await ref.get().then((value) => res = value);
    if (res.exists) {
      return res.value;
    } else {
      return;
    }
  }

  getAllSongs() async {}
}
