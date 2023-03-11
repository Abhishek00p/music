import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:file_picker/file_picker.dart';

import 'colors.dart';

class Upload extends StatefulWidget {
  final bool isSong;

  const Upload({super.key, required this.isSong});

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController songname = TextEditingController();
  TextEditingController artistname = TextEditingController();
  final categoryController = TextEditingController();
  late File image, song;
  late String imagepath, songpath;
  late Reference ref;
  var image_down_url, song_down_url;
  final firestoreinstance = FirebaseFirestore.instance;
  final _imgpicker = ImagePicker();
  bool imageSelected = false;
  bool songSelected = false;
  void selectimage() async {
    image =
        File((await _imgpicker.pickImage(source: ImageSource.gallery))!.path);

    setState(() {
      image = image;
      imagepath = basename(image.path);
      uploadimagefile(image.readAsBytesSync(), imagepath);
      imageSelected = true;
    });
  }

  Future<String> uploadimagefile(List<int> image, String imagepath) async {
    ref = FirebaseStorage.instance.ref().child(imagepath);
    UploadTask uploadTask = ref.putData(Uint8List.fromList(image));

    image_down_url = await (await uploadTask).ref.getDownloadURL();
    return image_down_url.toString();
  }

  void selectsong() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    song = File(result!.files.first.path.toString());

    setState(() {
      song = song;
      songpath = basename(song.path);
      uploadsongfile(song.readAsBytesSync(), songpath);
      songSelected = true;
    });
  }

  Future<String> uploadsongfile(List<int> song, String songpath) async {
    ref = FirebaseStorage.instance.ref().child(songpath);
    UploadTask uploadTask = ref.putData(Uint8List.fromList(song));

    song_down_url = await (await uploadTask).ref.getDownloadURL();
    return song_down_url.toString();
  }

  fileuploadTouser(String collectionName, data, context) async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final docu = await FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .collection(collectionName)
        .doc();
    docu.set(data).whenComplete(() => showDialog(
          context: context,
          builder: (context) =>
              _onTapButton(context, "Files Uploaded Successfully :)"),
        ));
  }

  finalupload(context) async {
    if (songname.text != '' &&
        artistname.text != '' &&
        song_down_url != null &&
        image_down_url != null) {
      print(songname.text);
      print(artistname.text);
      print(song_down_url);
      print(image_down_url.toString());

      var data = {
        "song_name": songname.text,
        "artist_name": artistname.text,
        "song_url": song_down_url.toString(),
        "image_url": image_down_url.toString(),
        "genere": categoryController.text.toString()
      };
      await fileuploadTouser(
          widget.isSong ? "Music" : "Podcast", data, context);
      firestoreinstance
          .collection(widget.isSong ? "UsersSongs" : "userPodcast")
          .doc()
          .set(data)
          .whenComplete(() => showDialog(
                context: context,
                builder: (context) =>
                    _onTapButton(context, "Files Uploaded Successfully :)"),
              ));
    } else {
      showDialog(
        context: context,
        builder: (context) =>
            _onTapButton(context, "Please Enter All Details :("),
      );
    }
  }

  _onTapButton(BuildContext context, data) {
    return AlertDialog(title: Text(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white24,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context, {
                        "title": songname.text,
                        "singer": artistname.text,
                        "gen": categoryController.text,
                        "img": image,
                        "isSong": widget.isSong
                      }),
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20))),
                        width: 80,
                        child: Center(
                          child: Text(
                            "Go back",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Column(
                          children: [
                            TextField(
                              controller: songname,
                              decoration: InputDecoration(
                                  fillColor: Colors.orangeAccent,
                                  filled: true,
                                  hintStyle: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                  label: Text(
                                    "Title",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: artistname,
                              decoration: InputDecoration(
                                fillColor: Colors.orangeAccent,
                                filled: true,
                                hintStyle: TextStyle(
                                    fontSize: 20, color: Colors.white),
                                label: Text(
                                  "Artist",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextField(
                              controller: categoryController,
                              decoration: InputDecoration(
                                fillColor: Colors.orangeAccent,
                                filled: true,
                                hintStyle: TextStyle(
                                    fontSize: 20, color: Colors.white),
                                label: Text(
                                  "Genere",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  imageSelected
                      ? Container(
                          height: 100,
                          width: 200,
                          child: Image.file(
                            image,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white)),
                          height: 100,
                          width: 200,
                          child: Center(
                            child: Text(
                              "Image",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () => selectimage(),
                    child: Container(
                        height: 30,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.deepOrange),
                            color: Colors.white),
                        child: Center(
                            child: Text(
                          "Select Image",
                        ))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  songSelected
                      ? Text(
                          "${songpath}",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                      : Text(
                          "example.mp3",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                  TextButton(
                    onPressed: () => selectsong(),
                    child: Container(
                        height: 30,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.deepOrange),
                            color: Colors.white),
                        child: Center(child: Text("Select Song"))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () => finalupload(context),
                    child: Container(
                        height: 50,
                        width: 170,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.deepOrange),
                            color: Colors.white),
                        child: Center(child: Text("Upload"))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
