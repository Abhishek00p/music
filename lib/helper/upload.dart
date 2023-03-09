import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:file_picker/file_picker.dart';

class Upload extends StatefulWidget {
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
  void selectimage() async {
    image =
        File((await _imgpicker.pickImage(source: ImageSource.gallery))!.path);

    setState(() {
      image = image;
      imagepath = basename(image.path);
      uploadimagefile(image.readAsBytesSync(), imagepath);
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
    });
  }

  Future<String> uploadsongfile(List<int> song, String songpath) async {
    ref = FirebaseStorage.instance.ref().child(songpath);
    UploadTask uploadTask = ref.putData(Uint8List.fromList(song));

    song_down_url = await (await uploadTask).ref.getDownloadURL();
    return song_down_url.toString();
  }

  finalupload(context) {
    if (songname.text != '' &&
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
        "category": categoryController.text.toString()
      };

      firestoreinstance
          .collection("songs")
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
      body: Center(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          TextButton(
            onPressed: () => selectimage(),
            child: Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(border: Border.all()),
                child: Text("Select Image")),
          ),
          TextButton(
            onPressed: () => selectsong(),
            child: Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(border: Border.all()),
                child: Text("Select Song")),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: TextField(
              controller: songname,
              decoration: InputDecoration(
                hintText: "Enter song name",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: TextField(
              controller: artistname,
              decoration: InputDecoration(
                hintText: "Enter artist name",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: TextField(
              controller: categoryController,
              decoration: InputDecoration(
                hintText: "Enter Category name",
              ),
            ),
          ),
          TextButton(
            onPressed: () => finalupload(context),
            child: Container(
                height: 30,
                width: 80,
                decoration: BoxDecoration(border: Border.all()),
                child: Text("Upload")),
          ),
        ],
      )),
    );
  }
}
