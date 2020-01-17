import 'package:flutter/material.dart';
import 'package:naberius_mobile/unit/model/info_model.dart';

class UnitAbility extends StatelessWidget {
  final UnitInfo unitInfo;
  UnitAbility(this.unitInfo);

  @override
  Widget build(BuildContext context) {
    var abilities = unitInfo.unit['Abilities'] as List<dynamic>;
    var isEvo = !(unitInfo.currentClass['Type'] == 'Init' ||
        unitInfo.currentClass == 'CC');
    if (unitInfo.unit['Rare'] == 2 && unitInfo.currentClass == 'CC') {
      isEvo = true;
    }
    var keyword = isEvo ? 'Evo' : 'Init';
    var i = abilities.indexWhere((e) => e['Type'] == keyword);
    List<Widget> list = [
      Divider(color: Colors.black45),
      Text(
        '能力',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    ];
    if (i == -1) {
      return Container(
        height: 0,
      );
    } else {
      var ability = abilities[i];
      var abilityName = ability['AbilityName'];
      var abilityText = ability['Text'] as String;
      abilityText = abilityText.replaceAll('\n', ' ');
      list.addAll(<Widget>[
        Row(
          children: <Widget>[
            Text(
              abilityName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: Text(abilityText),
            )
          ],
        )
      ]);
    }

    return Column(children: list);
  }
}
