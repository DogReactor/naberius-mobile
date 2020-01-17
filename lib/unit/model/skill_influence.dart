import 'package:naberius_mobile/unit/model/info_model.dart';

typedef OnEffect = void Function(
    UnitInfo unitInfo, num effectValue, bool isMulit);
typedef OnToString = String Function(
    num effectValue, bool isMulit, int targetType);

class SkillInfluence {
  final int typeId;
  final bool isEffect;
  final OnEffect onEffect;
  final OnToString onToString;
  SkillInfluence(
    this.typeId,
    this.isEffect,
    this.onEffect,
    this.onToString,
  );
}
