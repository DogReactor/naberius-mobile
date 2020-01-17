import 'package:flutter/material.dart';

typedef OnTap = void Function();

class UnitStatusRow extends StatelessWidget {
  final String left;
  final dynamic right;
  final String additionalString;
  final int additional;
  bool red;
  final OnTap onTap;
  UnitStatusRow({
    this.left,
    this.right,
    this.additional,
    this.additionalString,
    this.onTap,
    this.red = false,
  });
  @override
  Widget build(BuildContext context) {
    // 右边文字的Style
    TextStyle ts;
    if (onTap == null) {
      ts = TextStyle(fontSize: 18, color: red ? Colors.red : Colors.black);
    } else {
      ts = TextStyle(
          fontSize: 18,
          color: Colors.blue,
          decoration: TextDecoration.underline);
    }
    // 右边的文字
    List<Widget> texts = [
      GestureDetector(
        child: Text(
          right.toString(),
          style: ts,
        ),
        onTap: onTap == null ? () {} : onTap,
      )
    ];
    if (additional != null && additional != 0) {
      var additionalText =
          additional > 0 ? '+$additional' : additional.toString();
      texts.add(Text("($additionalText)",
          style: TextStyle(fontSize: 16, color: Colors.red)));
    }
    if (additionalString != null && additionalString != '') {
      texts.add(Text("($additionalString)",
          style: TextStyle(fontSize: 16, color: Colors.red)));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          left,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: texts,
          crossAxisAlignment: CrossAxisAlignment.center,
        )
      ],
    );
  }
}
