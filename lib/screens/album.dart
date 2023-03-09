import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/helper/audioPlayers.dart';
import 'package:music/helper/colors.dart';
import 'package:just_audio/just_audio.dart';

import 'package:share_plus/share_plus.dart';

class AlbumPage extends StatefulWidget {
  final song;

  const AlbumPage({super.key, required this.song});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final FavSongList = [
    {"Title": "Title", "Artist": "Artist", "image": "assets/arjit.jpg"},
    {"Title": "Title", "Artist": "Artist", "image": "assets/arjit.jpg"},
    {"Title": "Title", "Artist": "Artist", "image": "assets/arjit.jpg"},
  ];

  bool audioPlayingFromButton = false;
  bool audioPlaying = false;
  var _val = 0.0;
  AudioPlayer _audioPlayer = AudioPlayer();
  final _getcontroller = Get.put(AllAudioPlayers());

  var audioDuration;
  var currentValue = 0.0;
  var positionofSlider;
  int next = 1;
  @override
  void initState() {
    // print("res from album, :${widget.res}");
    positionofSlider = _audioPlayer.positionStream;
    audioDuration = _audioPlayer.durationStream;
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
      bottomNavigationBar: audioPlayingFromButton
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                width: w * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.black38),
                child: Column(
                  children: [
                    SizedBox(
                      height: 2,
                    ),
                    Container(
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
                            buffered: posData?.bufferPosition ?? Duration.zero,
                            onSeek: _audioPlayer.seek,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: w * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () async {
                                _audioPlayer.playerStateStream;
                                setState(() {
                                  next--;
                                });
                                var url = widget.song["song_url"];
                                // var totalNext = await widget.song["asha bosle"].keys
                                //     .toList()
                                //     .length;
                                // if (next >= 0) {
                                //   var url = await widget.res["asha bosle"][widget
                                //       .res["asha bosle"].keys
                                //       .toList()[next]]["url"];
                                //   print(
                                //       "next song : ${widget.res["asha bosle"].keys.toList()[next]}");
                                // print(url);
                                _audioPlayer.setUrl(url);
                                _audioPlayer.play();
                                // } else {
                                //   next = 0;
                                // }

                                setState(() {
                                  audioPlaying = _audioPlayer.playing;
                                  audioDuration = _audioPlayer.duration != null
                                      ? _audioPlayer.duration!.inMilliseconds
                                      : 0.0;
                                });
                              },
                              icon: Icon(
                                Icons.skip_previous,
                                size: 40,
                                color: Colors.orange,
                              )),
                          !audioPlaying
                              ? IconButton(
                                  onPressed: () async {},
                                  icon: Icon(
                                    Icons.play_arrow,
                                    size: 40,
                                    color: Colors.orange,
                                  ))
                              : IconButton(
                                  onPressed: () async {
                                    _audioPlayer.pause();
                                    setState(() {
                                      audioPlaying = _audioPlayer.playing;
                                      audioDuration =
                                          _audioPlayer.duration != null
                                              ? _audioPlayer
                                                  .duration!.inMilliseconds
                                              : 0.0;
                                    });
                                    print("audio :$audioDuration");
                                  },
                                  icon: Icon(
                                    Icons.pause,
                                    size: 40,
                                    color: Colors.orange,
                                  )),
                          IconButton(
                              onPressed: () async {
                                setState(() {
                                  next++;
                                });
                                var url = widget.song["song_url"];
                                _audioPlayer.setUrl(url);
                                _audioPlayer.play();

                                setState(() {
                                  audioPlaying = _audioPlayer.playing;
                                  audioDuration = _audioPlayer.duration != null
                                      ? _audioPlayer.duration!.inMilliseconds
                                      : 0.0;
                                });
                              },
                              icon: Icon(
                                Icons.skip_next,
                                size: 40,
                                color: Colors.orange,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(),
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
                height: h * 0.35,
                width: w * 0.9,
                padding: EdgeInsets.only(left: w * 0.04, right: w * 0.04),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.song["image_url"],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 100,
                child: Stack(
                  children: [
                    Positioned(
                        left: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Poppins",
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 35,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.favorite_border,
                                        size: 22,
                                        color: Colors.white,
                                      )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.downloading_outlined,
                                        size: 22,
                                        color: Colors.white,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        await Share.share(
                                            "https://www.youtube.com/");
                                      },
                                      icon: Icon(
                                        Icons.share,
                                        size: 22,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Positioned(
                      right: 20,
                      top: 25,
                      child: Container(
                        height: 50,
                        child: Center(
                          child: GestureDetector(
                              onTap: () async {
                                final lOFList =
                                    _getcontroller.audioPlayerList.length;
                                if (lOFList > 0) {
                                  for (var element
                                      in _getcontroller.audioPlayerList) {
                                    element.stop();
                                  }
                                }
                                _getcontroller.audioPlayerList
                                    .add(_audioPlayer);
                                setState(() {
                                  audioPlayingFromButton = true;
                                });
                                var url = widget.song["song_url"];

                                // var url = await widget.res["asha bosle"][widget
                                //     .res["asha bosle"].keys
                                //     .toList()[next]]["url"];
                                // print(url);
                                _audioPlayer.setUrl(url);
                                if (_audioPlayer.playing) {
                                  _audioPlayer.pause();
                                  setState(() {});
                                } else {
                                  _audioPlayer.play();
                                }

                                setState(() {
                                  audioPlaying = _audioPlayer.playing;
                                  audioDuration = _audioPlayer.duration != null
                                      ? _audioPlayer.duration as double
                                      : 0.0;
                                });
                                print("audio :$audioDuration");
                              },
                              child: Image.asset(
                                "assets/play.png",
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Your Favourite",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: h * 0.2,
                width: w * 0.9, color: Colors.amber,
                // child: BuildList(songsList: FavSongList, res: widget.res),
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
