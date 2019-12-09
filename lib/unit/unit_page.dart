import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import './unit.dart';
import './unit_detail.dart';

String getPrettyJSONString(Object jsonObject) {
  return const JsonEncoder.withIndent('').convert(jsonObject);
}

class UnitPage extends StatefulWidget {
  static const BottomNavigationBarItem navItem = BottomNavigationBarItem(
    icon: Icon(Icons.movie_filter),
    title: Text('单位'),
  );
  @override
  _UnitPageState createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
  var unitsList = [];
  var first = true;
  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: """
        {
          cards{
            Name
            CardID
            Rare
            NickName
            Race
            Kind
            Class{
              ClassInit{
                ClassID
                Name
                NickName
                BattleStyle{
                  Data_ID
                  Type_BattleStyle
                }
              }
            }
          }
        }
      """,
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
          final List<dynamic> units_raw = result.data['cards'];
          final List<dynamic> units = [];
          // TODO: 根据彩蛋默认屏蔽一些数据
          // 默认不显示非单位的东西（还需要完善）
          // 把它们挪到filter.dart里去
          units.addAll(units_raw.where((i) {
            var kind = i['Kind'];
            var classID = i['Class']['ClassInit']['ClassID'];
            var className = i['Class']['ClassInit']['Name'] as String;
            var name = i['Name'];
            return kind < 2 &&
                (classID < 40000 || classID > 100000) &&
                !className.contains('分身') &&
                !name.contains('ダミー');
          }));
          units.sort((a, b) => (b['CardID'] as int).compareTo(a['CardID']));
          if (first) {
            // TODO: 使用默认检索规则
            unitsList.addAll(units);
            // unitsList.addAll(units);
            first = false;
          }
          var listView = ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: unitsList.length,
              itemBuilder: (context, i) {
                final unit = unitsList[i];
                return Card(
                  child: InkWell(
                    onTap: () {
                      // 跳转到详情页
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) {
                        return UnitDetailInfo(unit);
                      }));
                    },
                    child: UnitInfo(unit: unit),
                  ),
                );
              });
          return Container(
            padding: EdgeInsets.only(top: 25),
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                    child: Stack(
                      children: <Widget>[
                        TextField(
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              left: 45,
                              top: 20,
                              bottom: 20,
                              right: 45,
                            ),
                            hasFloatingPlaceholder: false,
                            border: OutlineInputBorder(),
                            labelText: '搜索（ID，姓名，职业）',
                          ),
                          onSubmitted: (String text) {
                            if (text == '') {
                              setState(() {
                                unitsList.clear();
                                //FIXME: 使用和初次加载同样的检索规则
                                unitsList.addAll(units);
                              });
                              return;
                            }
                            setState(() {
                              unitsList.clear();
                              unitsList.addAll(units.where((i) {
                                // 简易搜索
                                final l = [];
                                l.add(i['Name']);
                                l.add(i['Race']);
                                l.add(i['Class']['ClassInit']['Name']);
                                if (i['NickName'] != null) {
                                  l.addAll(i['NickName']);
                                }
                                if (i['Class']['ClassInit']['NickName'] !=
                                    null) {
                                  l.addAll(i['Class']['ClassInit']['NickName']);
                                }
                                final s = l.join(' ');
                                return s.contains(text);
                              }).toList());
                            });
                          },
                        ),
                        // 打开侧边栏
                        Positioned(
                          child: IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: Colors.black45,
                              size: 25,
                            ),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                          left: 0,
                          top: 8,
                        ),
                        // 打开高级搜索
                        Positioned(
                          child: IconButton(
                            icon: Icon(Icons.add,
                                color: Colors.black45, size: 30),
                            onPressed: () {
                              setState(() {});
                            },
                          ),
                          right: 0,
                          top: 8,
                        )
                      ],
                    )),
                Expanded(
                    child: unitsList.length == 0
                        ? Center(
                            child: Text(
                            '没有数据',
                            style:
                                TextStyle(fontSize: 50, color: Colors.black26),
                          ))
                        : listView),
              ],
            ),
          );
        });
  }
}
