import 'package:flutter/material.dart';
import 'package:music/helper/colors.dart';

import '../helper/upload.dart';

class PostNavPage extends StatefulWidget {
  @override
  State<PostNavPage> createState() => _PostNavPageState();
}

class _PostNavPageState extends State<PostNavPage> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
        height: h,
        width: w,
        color: whitealpha,
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              "Tell us your Stories",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              indent: 60,
              thickness: 1.7,
              color: Colors.white,
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upload Song",
                      style: TextStyle(fontSize: 16, color: Colors.green[400]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: h * 0.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: h * 0.2,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.deepOrangeAccent)),
                            child: Center(
                              child: IconButton(
                                  onPressed: () async {
                                    final res = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Upload(isSong: true)));
                                  },
                                  icon: Icon(
                                    Icons.publish_rounded,
                                    size: 50,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Upload Podcast",
                      style: TextStyle(fontSize: 16, color: Colors.orange),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: h * 0.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: h * 0.2,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green[400]!)),
                            child: Center(
                              child: IconButton(
                                  onPressed: () async {
                                    final res = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Upload(
                                                  isSong: false,
                                                )));
                                  },
                                  icon: Icon(
                                    Icons.publish_rounded,
                                    size: 50,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              endIndent: 60,
              thickness: 1.7,
              color: Colors.white,
            ),
          ],
        ));
  }
}
