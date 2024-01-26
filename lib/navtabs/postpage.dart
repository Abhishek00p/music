import 'package:flutter/material.dart';
import 'package:music/helper/colors.dart';

import '../helper/upload.dart';

class PostNavPage extends StatefulWidget {
  const PostNavPage({super.key});

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Tell us your Stories",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(
                indent: 60,
                thickness: 1.7,
                color: Colors.white,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upload Song",
                        style:
                            TextStyle(fontSize: 16, color: Colors.green[400]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: h * 0.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: h * 0.2,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.deepOrangeAccent)),
                              child: Center(
                                child: IconButton(
                                    onPressed: () async {
                                      final res = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Upload(isSong: true)));
                                    },
                                    icon: const Icon(
                                      Icons.publish_rounded,
                                      size: 50,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Upload Podcast",
                        style: TextStyle(fontSize: 16, color: Colors.orange),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: h * 0.25,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: h * 0.2,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.green[400]!)),
                              child: Center(
                                child: IconButton(
                                    onPressed: () async {
                                      final res = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => const Upload(
                                                    isSong: false,
                                                  )));
                                    },
                                    icon: const Icon(
                                      Icons.publish_rounded,
                                      size: 50,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                endIndent: 60,
                thickness: 1.7,
                color: Colors.white,
              ),
            ],
          ),
        ));
  }
}
