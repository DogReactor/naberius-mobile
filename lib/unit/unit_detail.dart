import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './unit_query.dart';
import './unit_status.dart';
import './rare.dart';

const classConst = [
  'ClassInit',
  'ClassCC',
  'ClassEvo',
  'ClassEvo2a',
  'ClassEvo2b'
];
const classTextConst = ['初始', '转职', '觉醒', '二觉A', '二觉B'];

class UnitDetailInfo extends StatefulWidget {
  final dynamic u;
  UnitDetailInfo(this.u);
  @override
  _UnitDetailInfoState createState() => _UnitDetailInfoState();
}

class _UnitDetailInfoState extends State<UnitDetailInfo> {
  var selectedClass = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.u['Name']),
      ),
      body: Query(
        options: QueryOptions(
          document: UnitQuery,
          variables: {"id": widget.u['CardID']},
        ),
        builder: (
          QueryResult result, {
          BoolCallback refetch,
          FetchMore fetchMore,
        }) {
          if (result.errors != null) {
            return Text(result.errors.toString());
          }
          if (result.loading) {
            return Center(child: const CircularProgressIndicator());
          }
          final unit = result.data['card'];
          getIcons() {
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
                  setState(() {
                    print(state);
                    selectedClass = state;
                  });
                },
              );
            }

            // 英杰特殊处理
            if (unit['Rare'] >= 10) {
              return [getWidget(0)];
            }

            // 觉醒绘编号
            var evoIcon =
                (unit['ImageStand'] as List<dynamic>).length > 1 ? 1 : 0;
            var evo2aIcon =
                (unit['ImageStand'] as List<dynamic>).length > 2 ? 2 : 1;
            var evo2bIcon =
                (unit['ImageStand'] as List<dynamic>).length > 2 ? 3 : 1;
            // TODO: 魔狗要改
            List<GestureDetector> list = [];
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
            return list;
          }

          return ListView(
            padding: EdgeInsets.all(15.0),
            shrinkWrap: true,
            children: <Widget>[
              // 名字
              Center(
                child: Text(
                  unit['Name'],
                  style: TextStyle(fontSize: 28),
                ),
              ),
              // 稀有度
              Center(child: Rare(unit['Rare'])),
              // 画师
              // TODO: 这个可以点
              Center(
                child: Text(
                  'Illust: ${unit['Illust']}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              // Padding
              SizedBox(height: 20),
              // 形态
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: getIcons(),
              ),
              // 数据
              UnitStatus(selectedClass, unit),
            ],
          );
        },
      ),
    );
  }
}
