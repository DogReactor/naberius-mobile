import 'package:flutter/material.dart';
import '../model/info_model.dart';
import './unit_info_row.dart';

class UnitInfoWidget extends StatelessWidget {
  final UnitInfo unitInfo;
  UnitInfoWidget(this.unitInfo);
  @override
  Widget build(BuildContext context) {
    List<Widget> statusWidgets = [
      UnitStatusRow(
        left: '职业',
        right: unitInfo.currentClass['Name'],
      ),
      UnitStatusRow(
        left: '攻击类型',
        right: unitInfo.classType ? '近战' : '远程',
      ),
      UnitStatusRow(
        left: '等级',
        right: unitInfo.level,
      ),
      UnitStatusRow(
        left: 'HP',
        right: unitInfo.hp + unitInfo.bonus.hp,
        red: unitInfo.bonus.hp != 0,
      ),
      UnitStatusRow(
        left: '攻击力',
        right: unitInfo.atk + unitInfo.bonus.atk,
        red: unitInfo.bonus.atk != 0,
      ),
      UnitStatusRow(
        left: '防御力',
        right: unitInfo.def + unitInfo.bonus.def,
        red: unitInfo.bonus.def != 0,
      ),
      UnitStatusRow(
        left: '魔法抗性',
        right: unitInfo.resist + unitInfo.bonus.resist,
        red: unitInfo.bonus.resist != 0,
      ),
    ];
    if (unitInfo.classType) {
      // 如果是近战，显示挡数
      statusWidgets.add(UnitStatusRow(
        left: '阻挡数',
        right: unitInfo.block,
      ));
    }
    if (unitInfo.range > 40 || !unitInfo.classType) {
      // 如果射程大于40，显示射程
      statusWidgets.add(UnitStatusRow(
        left: '射程',
        right: unitInfo.range + unitInfo.bonus.range,
        red: unitInfo.bonus.range != 0,
      ));
    }
    statusWidgets.addAll([
      UnitStatusRow(
          left: '攻击后摇',
          right:
              (unitInfo.attackWait * (1 + unitInfo.bonus.stuck / 100)).ceil(),
          red: unitInfo.bonus.stuck != 0),
      UnitStatusRow(
        left: '攻击目标数',
        right: unitInfo.maxTarget,
      ),
      UnitStatusRow(
        left: 'Cost',
        right: unitInfo.cost,
        additionalString: (unitInfo.cost - unitInfo.costDec).toString(),
      )
    ]);
    statusWidgets = statusWidgets
        .asMap()
        .map((i, element) => MapEntry<int, Widget>(
              i,
              Container(
                height: 30,
                padding: EdgeInsets.only(left: 5, right: 5),
                color: i.isEven
                    ? Colors.transparent
                    : Theme.of(context).primaryColorLight.withOpacity(0.5),
                child: element,
              ),
            ))
        .values
        .toList();
    // 包装人物面板组件
    var statusWidget = Container(
      child: Column(
        children: statusWidgets,
      ),
    );
    return statusWidget;
  }
}
