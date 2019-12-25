import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './info_model.dart';
import './Widget/unit_info.dart';

// 根据选择的不同职业，渲染不同的属性
// 这里要根据职业，技能，被动，好感加成来综合计算属性

class UnitStatus extends StatefulWidget {
  // 0: 初始
  // 1: CC
  // 2: 觉醒
  // 3: 二觉A
  // 4: 二觉B
  final int selectedClass;
  final dynamic unit;
  UnitStatus(this.selectedClass, this.unit);
  @override
  _UnitStatusState createState() => _UnitStatusState();
}

class _UnitStatusState extends State<UnitStatus> {
  var isMax = true;
  final status = Status();
  @override
  Widget build(BuildContext context) {
    var currentClass = widget.unit['Classes'][widget.selectedClass];
    var unitInfo = UnitInfo(widget.unit, widget.selectedClass, isMax, status);
    // 返回Widget
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // 立绘
          CachedNetworkImage(
            imageUrl:
                'http://assets.millennium-war.net${currentClass['ImageStand']}',
            placeholder: (context, url) => Container(
              child: Center(child: CircularProgressIndicator()),
              height: 400,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            height: 400,
          ),
          // 切换开关
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Lv.1'),
                Switch(
                  value: isMax,
                  onChanged: (value) {
                    setState(() {
                      isMax = value;
                    });
                  },
                ),
                Text('Lv.Max')
              ],
            ),
          ),
          // 单位面板
          UnitInfoWidget(unitInfo),
          // 职业信息
          // 被动信息
          // 技能信息
        ],
      ),
    );
  }
}
