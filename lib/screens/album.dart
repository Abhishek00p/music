import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/helper/audioPlayers.dart';
import 'package:music/helper/colors.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toast/toast.dart';
import '../helper/download.dart';
import 'package:share_plus/share_plus.dart';

class AlbumPage extends StatefulWidget {
  final song;

  const AlbumPage({super.key, required this.song});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  var _val = 0.0;
  AudioPlayer _audioPlayer = AudioPlayer();
  final _getcontroller = Get.put(AllAudioPlayers());

  var audioDuration;
  var currentValue = 0.0;
  var positionofSlider;

  Future<List> getALlFavs() async {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    final firestoreUserDAta = await FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .collection("Fav")
        .get();

    return firestoreUserDAta.docs.toList();
  }

  bool isThisSongAddedtoFav = false;

  checkIfAddedtoFav() async {
    final allfav = await getALlFavs();
    for (var element in allfav) {
      final data = element.data();
      if (data["song_name"].toString().trim() ==
          widget.song["song_name"].toString().trim()) {
        setState(() {
          isThisSongAddedtoFav = true;
        });
      }
    }
  }

  @override
  void initState() {
    print("res from album, :${widget.song}");
    positionofSlider = _audioPlayer.positionStream;
    audioDuration = _audioPlayer.durationStream;
    checkIfAddedtoFav();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferPosition, duration) => PositionData(
              position, bufferPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: scaffColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
          child: Container(
        height: h,
        width: w,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      height: h * 0.45,
                      width: w * 0.9,
                      padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          widget.song["image_url"],
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.song["song_name"].toString(),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.song["artist_name"],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          color: Colors.greenAccent),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 100,
                child: Stack(
                  children: [
                    Positioned(
                      left: 15,
                      top: 2,
                      child: Container(
                        width: w * 0.8,
                        height: 10,
                        child: StreamBuilder<PositionData>(
                          stream: _positionDataStream,
                          builder: (context, snap) {
                            final posData = snap.data;
                            return ProgressBar(
                              timeLabelTextStyle:
                                  TextStyle(color: Colors.white, fontSize: 12),
                              thumbRadius: 8,
                              barHeight: 4,
                              baseBarColor: Colors.white.withOpacity(0.2),
                              thumbColor: Colors.red,
                              thumbGlowColor: Colors.yellow,
                              bufferedBarColor: Colors.white,
                              progressBarColor: Colors.orange,
                              progress: posData?.position ?? Duration.zero,
                              total: posData?.duration ?? Duration.zero,
                              buffered:
                                  posData?.bufferPosition ?? Duration.zero,
                              onSeek: _audioPlayer.seek,
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                        left: 0,
                        bottom: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 35,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        !isThisSongAddedtoFav
                                            ? await addmyFav(
                                                widget.song["song_name"],
                                                widget.song["artist_name"],
                                                widget.song["image_url"],
                                                widget.song["song_url"],
                                                widget.song["category"])
                                            : Toast.show(
                                                "Already added to the fav",
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    backgroundColor:
                                                        Colors.black,
                                                    fontSize: 16));
                                      },
                                      icon: Icon(
                                        !isThisSongAddedtoFav
                                            ? Icons.favorite_border
                                            : Icons.favorite,
                                        size: 30,
                                        color: Colors.white,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        Toast.show(
                                          "Download started",
                                          backgroundColor: Colors.green,
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                        );
                                        final file = await DownloadSong()
                                            .downloadSong(
                                                widget.song["song_url"],
                                                widget.song["song_name"]);
                                        Toast.show(
                                            "Song downloaded at ${file.path}",
                                            backgroundColor: Colors.green,
                                            textStyle:
                                                TextStyle(color: Colors.white),
                                            duration: 3);
                                      },
                                      icon: Icon(
                                        Icons.downloading_outlined,
                                        size: 30,
                                        color: Colors.greenAccent,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        await Share.share(
                                            "https://www.youtube.com/");
                                      },
                                      icon: Icon(
                                        Icons.share,
                                        size: 30,
                                        color: Colors.blueAccent,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Positioned(
                      right: 20,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: !_audioPlayer.playing
                            ? () async {
                                final lOFList =
                                    _getcontroller.audioPlayerList.length;
                                if (lOFList > 0) {
                                  for (var element
                                      in _getcontroller.audioPlayerList) {
                                    await element.stop();
                                  }
                                }
                                _getcontroller.audioPlayerList
                                    .add(_audioPlayer);

                                var url = widget.song["song_url"];

                                await _audioPlayer.setUrl(url);
                                if (_audioPlayer.playing) {
                                  _audioPlayer.pause();
                                  setState(() {});
                                } else {
                                  _audioPlayer.play();
                                }

                                setState(() {
                                  audioDuration = _audioPlayer.duration != null
                                      ? _audioPlayer.duration
                                      : 0.0;
                                });
                                print("audio :$audioDuration");
                              }
                            : () async {
                                await _audioPlayer.pause();
                                setState(() {});
                              },
                        child: !_audioPlayer.playing
                            ? Icon(
                                Icons.play_circle_outline_outlined,
                                size: 45,
                                color: Colors.orange,
                              )
                            : Icon(
                                Icons.pause_circle_outline,
                                size: 45,
                                color: Colors.orange,
                              ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferPosition;
  final Duration duration;

  PositionData(this.position, this.bufferPosition, this.duration);
}

addmyFav(songName, artist, albumimageurl, url, categ) async {
  final User user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final fireUserDocREf = firestore.collection("users").doc(user.uid);
  final fireUserFavRef = fireUserDocREf.collection("Fav");
  await fireUserFavRef.doc().set({
    "song_name": songName,
    "artist_name": artist,
    "category": categ,
    "image_url": albumimageurl,
    "song_url": url,
  });

  Toast.show("Song added to your FavSongs",
      textStyle: TextStyle(color: Colors.black, fontSize: 16),
      duration: 2,
      backgroundColor: Colors.white);
}
