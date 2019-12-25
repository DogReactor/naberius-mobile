import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef OnChange = void Function(int state);

class UnitPhase extends StatelessWidget {
  final OnChange onChange;
  final int selectedClass;
  final dynamic unit;
  UnitPhase({@required this.onChange, this.selectedClass, this.unit});

  @override
  Widget build(BuildContext context) {
    getWidget(int state) {
      var currentClass = unit['Classes'][state];
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
                    'https://aigisapi.naberi.us/static/ico/${currentClass['IconIndex']}/${unit['CardID']}.png',
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
              Text(currentClass['TypeText']),
            ],
          ),
        ),
        onTap: () {
          this.onChange(state);
        },
      );
    }

    List<Widget> list = [];
    for (var i = 0; i < unit['Classes'].length; i++) {
      if (unit['Classes'][i]['IsRenderer']) {
        list.add(getWidget(i));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: list,
    );
  }
}
