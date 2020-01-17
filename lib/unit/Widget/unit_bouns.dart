import 'package:flutter/material.dart';
import 'package:naberius_mobile/unit/model/info_model.dart';

class UnitBonusWidget extends StatelessWidget {
  final unit;
  UnitBonusWidget(this.unit);
  @override
  Widget build(BuildContext context) {
    var list = <Widget>[];
    if (unit['Rare'] > 1) {
      valueFormat(int type, value) {
        value = value.round();
        if (type == 6) {
          return '-$value%';
        }
        if (type == 7) {
          return '+$value%';
        }
        if (type == 8) {
          return '-$value%';
        }
        if (type == 9) {
          return '$value%';
        } else {
          return '+$value';
        }
      }

      // 好感1
      var bonus1Text = BonusType[unit['BonusType']];
      var bouns1Value = valueFormat(unit['BonusType'], unit['BonusNum'] * 1.2);
      // 好感2
      var bonus2Text = BonusType[unit['BonusType2']];
      var bouns2Value =
          valueFormat(unit['BonusType2'], unit['BonusNum2'] * 1.2);
      // 好感3
      var bonus3Text = BonusType[unit['BonusType3']];
      var bouns3Value =
          valueFormat(unit['BonusType3'], unit['BonusNum3']);
      if (bonus1Text != '无') {
        list.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$bonus1Text'),
              Text(' $bouns1Value'),
            ],
          ),
        );
      }
      if (bonus2Text != '无') {
        list.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$bonus2Text'),
              Text(' $bouns2Value'),
            ],
          ),
        );
      }
      if (bonus3Text != '无') {
        list.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$bonus3Text'),
              Text(' $bouns3Value'),
            ],
          ),
        );
      }
    } else {
      list.add(Text('无'));
    }
    return Column(
      children: <Widget>[
        Text(
          '好感度奖励',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          width: 200,
          child: Column(
            children: list,
          ),
        )
      ],
    );
  }
}
