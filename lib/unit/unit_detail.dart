import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:naberius_mobile/unit/Widget/unit_phase.dart';
import './unit_query.dart';
import './unit_status.dart';
import './rare.dart';

class UnitDetailInfo extends StatefulWidget {
  final dynamic u;
  UnitDetailInfo(this.u);
  @override
  _UnitDetailInfoState createState() => _UnitDetailInfoState();
}

// TODO: 遥远的计划 - appBar右侧按钮进入buff选择栏，可以选择各种buff
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
              // 种族
              Center(
                child: Text(
                  '${unit['Race']}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
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
              // 切换不同转职
              UnitPhase(
                unit: unit,
                selectedClass: selectedClass,
                onChange: (state) {
                  setState(() {
                    selectedClass = state;
                  });
                },
              ),
              // 单位详情数据
              UnitStatus(selectedClass, unit),
            ],
          );
        },
      ),
    );
  }
}
