import 'package:flutter/material.dart';
import 'package:naberius_mobile/unit/model/skill_config.dart';
import 'package:naberius_mobile/unit/tool/compiler.dart';
import '../model/info_model.dart';

class UnitSkill extends StatelessWidget {
  final UnitInfo unitInfo;
  final dynamic unit;
  final int selectedClass;
  UnitSkill(this.unitInfo, this.unit, this.selectedClass);

  @override
  Widget build(BuildContext context) {
    List<Widget> columnList = [
      new Divider(color: Colors.black45),
      Text(
        '技能',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    ];
    if (unit['Rare'] < 2) {
      return Container(
        height: 0,
      );
    }
    var skills = unit['Skills'];
    var hasCCSkill = skills.length == 3;
    var initSkillsWidget = (skills[0]['Skills'] as List<dynamic>).map((e) {
      return SkillDetail(
        Skill(
          unit: unit,
          rawSkill: e,
          selectedClass: unit['Classes'][selectedClass],
          unitInfo: unitInfo,
          isEvo: false,
        ),
        unitInfo,
      );
    });
    var ccSkillsWidget = <Widget>[];
    if (hasCCSkill) {
      ccSkillsWidget = (skills[1]['Skills'] as List<dynamic>).map((e) {
        return SkillDetail(
          Skill(
            unit: unit,
            rawSkill: e,
            selectedClass: unit['Classes'][selectedClass],
            unitInfo: unitInfo,
            isEvo: false,
          ),
          unitInfo,
        );
      }).toList();
    }
    var evoSkillsWidget =
        (skills[hasCCSkill ? 2 : 1]['Skills'] as List<dynamic>).map((e) {
      return SkillDetail(
        Skill(
          unit: unit,
          rawSkill: e,
          selectedClass: unit['Classes'][selectedClass],
          unitInfo: unitInfo,
          isEvo: true,
        ),
        unitInfo,
      );
    });

    // 觉醒前技能
    List<Widget> init = [
      Row(children: <Widget>[
        Text(
          '初始技能',
          style: TextStyle(fontSize: 12),
        )
      ]),
    ];
    init.addAll(initSkillsWidget);
    // 转职后技能
    List<Widget> cc = [
      Row(children: <Widget>[
        Text(
          '转职技能',
          style: TextStyle(fontSize: 12),
        )
      ]),
    ];
    cc.addAll(ccSkillsWidget);
    // 觉醒后技能
    List<Widget> evo = [
      Row(children: <Widget>[
        Text(
          '觉醒技能',
          style: TextStyle(fontSize: 12),
        )
      ]),
    ];
    evo.addAll(evoSkillsWidget);

    if (unit['Rare'] >= 10) {
      columnList.addAll(init);
      columnList.add(new Divider());
      columnList.addAll(evo);
    } else {
      if (selectedClass == 0) {
        columnList.addAll(init);
      }
      if (selectedClass == 1 && unit['hasCC']) {
        if (hasCCSkill)
          columnList.addAll(cc);
        else
          columnList.addAll(init);
      }
      if (selectedClass > 1 || (selectedClass == 1 && !unit['hasCC'])) {
        columnList.addAll(hasCCSkill ? cc : init);
        columnList.add(new Divider());
        columnList.addAll(evo);
      }
    }

    return Column(
      children: columnList,
    );
  }
}

class SkillDetail extends StatelessWidget {
  final Skill skill;
  final UnitInfo unitInfo;
  SkillDetail(this.skill, this.unitInfo);

  Widget get skillText {
    // 只需要处理[]就可以了
    if (skill.text.contains('|')) {
      var ta = skill.text.split('|');
      var list = <TextSpan>[];
      for (var i = 0; i < ta.length; i++) {
        list.add(TextSpan(
          text: ta[i],
          style: TextStyle(color: i.isOdd ? Colors.red : Colors.black),
        ));
      }
      return RichText(text: TextSpan(children: list));
    } else
      return Text(skill.text);
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 技能名
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${skill.name}', style: textStyle),
            ],
          ),
          Container(
            // 最大等级， 初动再动
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  skill.isEvo ? ' ' : 'MaxLv.${skill.maxLevel}',
                ),
                Row(
                  children: <Widget>[
                    Text('初动 ${skill.firstTime}秒/'),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(text: '再动 '),
                          TextSpan(
                            text: '${skill.waitTime}',
                            style: TextStyle(
                                color: unitInfo.bonus.skillCD == 0
                                    ? Colors.black
                                    : Colors.red),
                          ),
                          TextSpan(text: '秒')
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          // 技能说明
          this.skillText
          // TODO: 技能效果
        ],
      ),
    );
  }
}

class SkillNotification extends Notification {
  SkillNotification({@required extraStatus});
}
