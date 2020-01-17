import 'package:naberius_mobile/unit/model/skill_influence.dart';

var inFluences = [
  // 攻击加成
  SkillInfluence(
    2,
    false,
    (unitInfo, value, isMulit) {},
    (value, isMulit, targetType) {
      return '';
    },
  ),
  // 全体攻击加成(锅盖)
  SkillInfluence(
    3,
    false,
    (unitInfo, value, isMulit) {},
    (value, isMulit, targetType) {
      return '';
    },
  ),
  // 指定攻击加成（铁匠）
  SkillInfluence(
    89,
    false,
    (unitInfo, value, isMulit) {},
    (value, isMulit, targetType) {
      return '';
    },
  ),
  // 永续攻击加成（QB）
  SkillInfluence(
    141,
    false,
    (unitInfo, value, isMulit) {},
    (value, isMulit, targetType) {
      return '';
    },
  )
];
