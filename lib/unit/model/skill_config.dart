import 'package:naberius_mobile/unit/model/info_model.dart';
import 'package:naberius_mobile/unit/model/skill_influence.dart';
import 'package:naberius_mobile/unit/tool/compiler.dart';

calcEffectValue(config, power) {
  var base = power;
  if (config['Data_MulValue3'] != 0) {
    base = config['Data_MulValue3'];
  }
  var count =
      (base * config['Data_MulValue'] / 100 * config['Data_MulValue2'] / 100) /
          100;
  if (config['Data_AddValue'] != 0) {
    count = config['Data_AddValue'];
  }
  return count;
}

class Skill {
  dynamic rawSkill;
  List<SkillConfig> skillConfigList = [];
  int powerMax;
  int power;
  String text;
  num firstTime;
  num waitTime;
  String name;
  bool isEvo;
  int maxLevel;
  Skill({unit, rawSkill, selectedClass, UnitInfo unitInfo, bool isEvo}) {
    this.rawSkill = rawSkill;
    this.isEvo = isEvo;
    powerMax = rawSkill['PowerMax'];
    power = rawSkill['Power'];
    name = rawSkill['SkillName'];
    maxLevel = rawSkill['LevelMax'];
    // 在这里解析所有Config，并且只保留actived的
    // 表达式分为两种，_ExpressionActivate表示该Config是否激活
    // _Expression表示该Config是否生效
    // 是否生效要看单位，在具体计算Config效果的时候进行
    List<dynamic> configs = rawSkill['Configs'];
    configs.forEach((config) {
      // 验证expressionActivate
      var expression = config['_ExpressionActivate'];
      var result = eval(expression, selectedClass, unit, rawSkill);
      if (result == 1)
        skillConfigList.add(SkillConfig(config, rawSkill['PowerMax']));
    });

    findConfig(List<int> typeid) {
      var matchedConfig = skillConfigList
          .where((element) => typeid.contains(element.influenceType))
          .toList();
      if (matchedConfig.length == 0)
        return '';
      else
        return matchedConfig[0].effectValue.toString();
    }

    ///////////////////
    // 解析说明文本
    ///////////////////
    /// TODO: 检查有没有更改说明文本的那个config
    String s = rawSkill['Text'];
    s = s.replaceAll('\n', ' ');
    // 处理<POW_R>
    s = s.replaceAll('<POW_R>', (powerMax / 100).toString());
    s = s.replaceAll('<POW_L>', (power / 100).toString());
    // 处理<ATK>
    s = s.replaceAll('<ATK>', findConfig([2, 141, 3, 89]));
    // 处理<RNG>
    s = s.replaceAll('<RNG>', findConfig([6]));
    // 处理<DEF>
    s = s.replaceAll('<DEF>', findConfig([4]));
    // 处理<NUM_SHOT>
    s = s.replaceAll('<NUM_SHOT>', findConfig([7]));
    // 处理<NUM_TRG>
    s = s.replaceAll('<NUM_TRG>', findConfig([22]));
    // 处理<MDEF>
    s = s.replaceAll('<MDEF>', findConfig([19]));
    // 处理<TIME>
    num skillTime = rawSkill['ContTimeMax'];
    skillTime = skillTime * (100 + unitInfo.bonus.skillTime) / 100;
    skillTime = skillTime.floor();
    var hasBonus = unitInfo.bonus.skillTime != 0;
    if (hasBonus) {
      s = s.replaceAll('<TIME>', '|$skillTime|');
    } else {
      s = s.replaceAll('<TIME>', '$skillTime');
    }
    text = s;

    //////////////////////
    // 计算初动再动
    //////////////////////
    firstTime = rawSkill['WaitTime'];
    if (unit['Rare'] == 5 || unit['Rare'] == 11) firstTime = isEvo ? 5 : 1;
    if (unit['Rare'] == 4 || unit['Rare'] == 10)
      firstTime = rawSkill['WaitTime'] / 2;
    if (unit['Rare'] == 7) firstTime = rawSkill['WaitTime'] / 3 * 2;
    if (unit['Rare'] == 3) firstTime = rawSkill['WaitTime'] / 5 * 3;

    waitTime = rawSkill['WaitTime'] - rawSkill['LevelMax'];
    waitTime = waitTime * (100 - unitInfo.bonus.skillCD) / 100;
  }
}

class SkillConfig {
  int influenceType;
  num effectValue;
  bool isMulit = true;
  bool isEffect;
  SkillInfluence skillInfluence;
  int targetType; // 1 敌人？ 2 自身 3 范围 4 全体
  String expression;
  SkillConfig(dynamic config, int power) {
    influenceType = config['Data_InfluenceType'];
    targetType = config['Data_Target'];
    expression = config['_Expression'];
    // 计算效果量
    var base = power;
    if (config['Data_MulValue3'] != 0) {
      base = config['Data_MulValue3'];
    }
    num count = (base *
            config['Data_MulValue'] /
            100 *
            config['Data_MulValue2'] /
            100) /
        100;
    if (config['Data_AddValue'] != 0) {
      isMulit = false;
      count = config['Data_AddValue'];
    }
    this.effectValue = count;

    // 例外
    if (influenceType == 7 && config['Data_AddValue'] == 0) {
      this.effectValue *= 100;
      this.effectValue = this.effectValue.toInt();
    }
    // 从数据集里面拿对应的效果信息
  }
}
