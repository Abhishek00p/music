import 'package:flutter/material.dart';

class FavSongs extends StatefulWidget {
  const FavSongs({super.key});

  @override
  State<FavSongs> createState() => _FavSongsState();
}

class _FavSongsState extends State<FavSongs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("your fav"),
      ),
    );
  }
}
