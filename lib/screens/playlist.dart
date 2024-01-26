import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/helper/colors.dart';
import 'album.dart';

class PlayListPlayer extends StatefulWidget {
  final List res;
  final ArtistName;
  final ArtistImage;
  const PlayListPlayer(
      {super.key,
      required this.res,
      required this.ArtistName,
      this.ArtistImage});

  @override
  State<PlayListPlayer> createState() => _PlayListPlayerState();
}

class _PlayListPlayerState extends State<PlayListPlayer> {
  @override
  void initState() {
    super.initState();
  }

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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: h * 0.3,
                        width: w * 0.7,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            widget.ArtistImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Singer ${widget.ArtistName}",
                        style: const TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "All time Best from ${widget.ArtistName}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                  child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.res.length,
                itemBuilder: (context, ind) {
                  print(widget.res.length);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: GestureDetector(
                      onTap: () => Get.to(
                        () => AlbumPage(song: widget.res[ind]),
                      ),
                      child: Container(
                        height: 40,
                        width: w - 60,
                        decoration: BoxDecoration(
                            color: Colors.grey[400]!.withOpacity(0.2),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20))
                            // border: Border.all(color: Colors.white)
                            ),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.network(
                                widget.res[ind]["image_url"].toString(),
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.res[ind]["song_name"].toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      )),
    );
  }
}
