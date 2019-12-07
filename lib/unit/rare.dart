import 'package:flutter/material.dart';

String getStars(int count) {
  final star = [
    "★",
    "★★",
    "★★★",
    "★★★★",
    "☆☆☆☆☆",
    "★★★★★★",
  ];
  return count >= star.length ? "???" : star[count];
}

Color getStarColor(int rare) {
  final colors = [
    const Color(0xff808080),
    const Color(0xffa52a2a),
    const Color(0xffc0c0c0),
    const Color(0xffffd700),
    Colors.black,
    Colors.black,
  ];
  return rare >= colors.length ? Colors.black : colors[rare];
}

class Rare extends StatelessWidget {
  final int rare;
  Rare(this.rare);
  @override
  Widget build(BuildContext context) {
    return Text(
      getStars(rare),
      style: TextStyle(
        color: getStarColor(rare),
      ),
    );
  }
}
