import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:music/screens/album.dart';

class BuildList extends StatefulWidget {
  final res;
  BuildList({required this.res});

  @override
  State<BuildList> createState() => _BuildListState();
}

class _BuildListState extends State<BuildList> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    // print("res from listviewbuiuld, :${widget.res}");

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: widget.res.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AlbumPage(
                            song: widget.res[index],
                          )));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                height: h * 0.2,
                width: w * 0.4,
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        child: Container(
                          height: h * 0.15,
                          width: w * 0.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              widget.res[index]["image_url"],
                              fit: BoxFit.fill,
                            ),
                          ),
                        )),
                    Positioned(
                        bottom: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.res[index]["song_name"].toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              widget.res[index]["artist_name"].toString(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ));
      },
    );
  }
}
