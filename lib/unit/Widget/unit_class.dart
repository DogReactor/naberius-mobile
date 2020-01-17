import 'package:flutter/material.dart';

import '../model/info_model.dart';

class UnitClass extends StatelessWidget {
  UnitInfo unitInfo;
  UnitClass(this.unitInfo);

  @override
  Widget build(BuildContext context) {
    var className = unitInfo.currentClass['Name'];
    var classText = unitInfo.currentClass['Explanation'] as String;
    classText = classText.replaceAll('\n', '');
    return Column(
      children: <Widget>[
        new Divider(color: Colors.black45),
        Text(
          '职业',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Row(
          children: <Widget>[
            Text(
              className,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: Text(classText),
            )
          ],
        )
      ],
    );
  }
}
