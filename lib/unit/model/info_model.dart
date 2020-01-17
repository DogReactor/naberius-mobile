const classMap = ['Init', 'CC', 'Evo', 'Evo2a', 'Evo2b'];

class Status {
  bool enableAbility = true;
  bool enalbeClass = true;
  // 0 初始技能；1 CC技能；2 觉醒技能
  int enableSkill = -1;
}

class UnitInfo {
  dynamic currentClass;
  int level = 1;
  int hp = 0;
  int atk = 0;
  int def = 0;
  int resist = 0;
  int block = 0;
  int cost = 0;
  int range = 0;
  int attackWait = 0;
  int maxTarget = 0;
  int costDec = 0;
  dynamic unit;
  // true为近战，false为远程
  bool classType = true;
  UnitBuff unitBuff = new UnitBuff();
  UnitBonus bonus;

  UnitInfo(dynamic unit, int selectedClass, bool max, Status status) {
    // 先计算等级吧
    this.unit = unit;
    this.currentClass = unit['Classes'][selectedClass];
    var maxLevel = currentClass['MaxLevelUnit'];
    var classMaxLevel = currentClass['MaxLevel'];
    var initClass = unit['Classes'][0];
    this.level = max ? maxLevel : 1;
    this.bonus = UnitBonus(unit, selectedClass);
    // 计算不包含bonus的属性
    // 职业基础值 + (职业最大值 - 职业基础值) / 99 * level + 个人补正

    getStatus(String arg1, String arg2, String arg3) {
      var init = currentClass[arg1];
      var max = currentClass[arg2];
      var mod = unit[arg3] / 100;
      var pointPerLevel = (max - init) / classMaxLevel;
      var base = init + pointPerLevel * this.level;
      var finalPoint = (base * mod) as double;
      if (level == 1 || level == classMaxLevel)
        return finalPoint.round();
      else
        return finalPoint.ceil();
    }

    // 计算基本属性
    this.hp = getStatus('InitHP', 'MaxHP', 'MaxHPMod');
    this.atk = getStatus('InitAtk', 'MaxAtk', 'AtkMod');
    this.def = getStatus('InitDef', 'MaxDef', 'DefMod');
    this.resist = unit['MagicResistance'];
    this.block = currentClass['BlockNum'];
    this.attackWait = currentClass['AttackWait'];
    this.range = currentClass['AtkArea'];
    if (initClass['BattleStyle'] != null) {
      var _r = initClass['BattleStyle']['_Range_0${selectedClass + 1}'];
      this.range = _r == 0 ? this.range : _r;
    }
    this.cost = currentClass['Cost'] + unit['CostModValue'];
    this.costDec = unit['CostDecValue'];
    this.maxTarget = currentClass['MaxTarget'];
    if ((currentClass['ClassID'] >= 10000 && currentClass['ClassID'] < 20000) ||
        (currentClass['ClassID'] >= 30000)) this.classType = false;
    // TODO:
    // 计算职业加成(应该都写在职业里了吧)

    // 计算被动加成(先翻翻WIKI)

    // 计算技能加成(遥远的计划)
  }
}

const BonusType = [
  '无',
  'HP',
  '攻击力',
  '防御力',
  '射程',
  '魔法耐性',
  '攻击硬直',
  '技能持续时间',
  '技能冷却时间',
  '物理攻击回避'
];

class UnitBonus {
  int hp = 0;
  int atk = 0;
  int def = 0;
  int range = 0;
  int resist = 0;
  int stuck = 0;
  int skillTime = 0;
  int skillCD = 0;
  int miss = 0;

  UnitBonus(dynamic unit, int selectedClass) {
    addBonus(int type, int value) {
      switch (type) {
        case 1: // 1 HP
          this.hp += value;
          break;
        case 2: // 2 攻击力
          this.atk += value;
          break;
        case 3: // 3 防御力
          this.def += value;
          break;
        case 4: // 4 射程
          this.range += value;
          break;
        case 5: // 5 魔法耐性
          this.resist += value;
          break;
        case 6: // 6 攻击硬直
          this.stuck -= value;
          break;
        case 7: // 7 技能持续时间
          this.skillTime += value;
          break;
        case 8: // 8 技能CD
          this.skillCD = value;
          break;
        case 9: // 9 物理攻击回避
          this.miss += value;
          break;
      }
    }

    // 银单位一下直接返回
    if (unit['Rare'] < 2) return;
    // 好感奖励系数
    double c;
    isChibi() {
      return unit['Rare'] == 3 && unit['Classes'].length == 1;
    }

    if (unit['Rare'] >= 10 || isChibi()) {
      c = 1 / 1.2;
    } else {
      c = (selectedClass == 0 && unit['hasCC']) ? 2 : (1 / 1.2);
    }
    addBonus(unit['BonusType'], (unit['BonusNum'] / c as double).round());
    addBonus(unit['BonusType2'], (unit['BonusNum2'] / c as double).round());
    if (isChibi() || (!(selectedClass == 0 && unit['hasCC']))) {
      addBonus(unit['BonusType3'], unit['BonusNum3']);
    }
  }
}

class UnitBuff {
  double atkMulit = 0.0;
  double defMulit = 0.0;
  double hpMulit = 0.0;
}
