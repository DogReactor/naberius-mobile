import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './rare.dart';

class UnitInfo extends StatelessWidget {
  UnitInfo({@required this.unit});
  final dynamic unit;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        gradient: new LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.white,
              unit['Kind'] == 0 ? Colors.blue[100] : Colors.pink[100],
            ]),
      ),
      height: 150,
      child: Row(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl:
                'https://aigisapi.naberi.us/static/ico/0/${unit['CardID']}.png',
            placeholder: (context, url) => Container(
              child: CircularProgressIndicator(),
              width: 70,
              height: 70,
            ),
            errorWidget: (context, url, error) => Icon(Icons.error, size: 70),
            height: 70,
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                // ID
                // TODO: 根据彩蛋配置是否显示ID
                Positioned(
                  child: Text(
                    '#${unit['CardID']}',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 45, color: Colors.black12),
                  ),
                  top: -5,
                  right: 0,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // 名字
                      Text(
                        unit['Name'],
                        style: TextStyle(fontSize: 18),
                      ),
                      // 稀有度
                      Rare(unit['Rare']),
                      // 初始职业
                      Text(unit['Class']['ClassInit']['Name']),
                      // 种族
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
