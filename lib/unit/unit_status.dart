import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './info_model.dart';

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
  var isMax = false;
  @override
  Widget build(BuildContext context) {
    var imageMap = [
      0,
      0,
      (widget.unit['ImageStand'] as List<dynamic>).length > 1 ? 1 : 0,
      (widget.unit['ImageStand'] as List<dynamic>).length > 2 ? 2 : 1,
      (widget.unit['ImageStand'] as List<dynamic>).length > 2 ? 3 : 1,
    ];
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // 立绘
          CachedNetworkImage(
            imageUrl:
                'http://assets.millennium-war.net${widget.unit['ImageStand'][imageMap[widget.selectedClass]]}',
            placeholder: (context, url) => Container(
              child: Center(child: CircularProgressIndicator()),
              height: 500,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
            height: 500,
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
          // 内容
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[],
          )
        ],
      ),
    );
  }
}
