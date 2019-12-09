import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef OnChange = void Function(int state);
const classConst = [
  'ClassInit',
  'ClassCC',
  'ClassEvo',
  'ClassEvo2a',
  'ClassEvo2b'
];
const classTextConst = ['初始', '转职', '觉醒', '二觉A', '二觉B'];

class UnitPhase extends StatelessWidget {
  final OnChange onChange;
  final int selectedClass;
  final dynamic unit;
  UnitPhase({@required this.onChange, this.selectedClass, this.unit});

  @override
  Widget build(BuildContext context) {
    getWidget(int state, {int iconState}) {
      var s = iconState == null ? state : iconState;
      return GestureDetector(
        child: Container(
          // height: 100,
          // width: 100,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: state == selectedClass
                    ? Theme.of(context).primaryColorLight
                    : Colors.transparent,
                blurRadius: 0,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl:
                    'https://aigisapi.naberi.us/static/ico/$s/${unit['CardID']}.png',
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(),
                  width: 70,
                  height: 70,
                ),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, size: 70),
                height: 70,
                width: 70,
              ),
              Text(classTextConst[state]),
            ],
          ),
        ),
        onTap: () {
          this.onChange(state);
        },
      );
    }

    List<Widget> list = [];
    // 英杰特殊处理
    if (unit['Rare'] >= 10) {
      list.add(getWidget(0));
    } else {
      // 觉醒绘编号
      var evoIcon = (unit['ImageStand'] as List<dynamic>).length > 1 ? 1 : 0;
      var evo2aIcon = (unit['ImageStand'] as List<dynamic>).length > 2 ? 2 : 1;
      var evo2bIcon = (unit['ImageStand'] as List<dynamic>).length > 2 ? 3 : 1;
      // TODO: 魔狗要改
      var classes = unit['Class'];
      // Init
      if (classes[classConst[0]] != null) {
        list.add(getWidget(0));
      }
      // CC
      if (classes[classConst[1]] != null) {
        list.add(getWidget(1, iconState: 0));
      }
      // Evo
      if (classes[classConst[2]] != null) {
        list.add(getWidget(2, iconState: evoIcon));
      }
      var awakePattern = unit['_AwakePattern'];
      // Evo2a
      if (awakePattern == 3 || awakePattern == 1) {
        list.add(getWidget(3, iconState: evo2aIcon));
      }
      // Evo2b
      if (awakePattern == 3 || awakePattern == 2) {
        list.add(getWidget(4, iconState: evo2bIcon));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: list,
    );
  }
}
