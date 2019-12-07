class UnitInfo {
  String className = '';
  int level = 1;
  int hp = 0;
  int atk = 0;
  int def = 0;
  int resist = 0;
  int block = 0;
  int cost = 0;
  int range = 0;
  int stuck = 0;
  UnitBonus bonus;

  UnitInfo(dynamic unit, int selectedClass, bool max) {
    // 先计算等级吧
    const initMaxLevel = [30, 40, 50, 50, 50, 50, 1, 50, 1, 1, 90, 99];
    const ccMaxLevel = [30, 40, 55, 60, 70, 80, 1, 65, 1, 1, 90, 99];
    const evoMaxLevel = [30, 40, 55, 80, 90, 99, 1, 85, 1, 1, 90, 99];
    var maxLevel = 1;
    var rare = unit['Rare'];
    if (selectedClass == 0) {
      maxLevel = unit['class']['ClassCC'] == null
          ? ccMaxLevel[rare]
          : initMaxLevel[rare];
    }
    if (selectedClass == 1) maxLevel = ccMaxLevel[rare];
    if (selectedClass == 2) maxLevel = evoMaxLevel[rare];
    if (selectedClass > 2) maxLevel = 99;
    this.level = max ? maxLevel : 1;
    this.bonus = UnitBonus(unit);
    // 
  }
}

class UnitBonus {
  int hp = 0;
  int atk = 0;
  int def = 0;
  int range = 0;
  int resist = 0;
  int stuck = 0;
  int skillTime = 0;
  int skillCD = 0;

  UnitBonus(dynamic unit) {
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
          this.stuck += value;
          break;
        case 7: // 7 技能持续时间
          this.skillTime += value;
          break;
        case 8: // 8 技能CD
          this.skillCD += value;
      }
    }

    addBonus(unit['BonusType'], unit['BounsNum']);
    addBonus(unit['BonusType2'], unit['BounsNum2']);
    addBonus(unit['BonusType3'], unit['BounsNum3']);
  }
}
