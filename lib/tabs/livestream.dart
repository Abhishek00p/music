
import 'package:flutter/material.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({super.key});

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("your livestream"),
      ),
    );
  }
}
