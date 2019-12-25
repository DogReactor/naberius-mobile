const maxLevelTable = [
  [30, 40, 50, 50, 50, 50, -1, 50, -1, -1, 50, 50],
  [-1, -1, 55, 60, 70, 80, -1, 65, -1, -1, 70, 80],
  [-1, -1, -1, 80, 90, 99, -1, 85, -1, -1, 90, 99],
  [-1, -1, -1, 99, 99, 99, -1, 99, -1, -1, 90, 99],
  [-1, -1, -1, 99, 99, 99, -1, 99, -1, -1, 90, 99],
];

const classTypeToIndex = {'Init': 0, 'CC': 1, 'Evo': 2, 'Evo2a': 3, 'Evo2b': 4};
const classTextConst = ['初始', '转职', '觉醒', '二觉A', '二觉B'];

unitClassPerTreat(unit) {
  final classes = unit['Classes'] as List<dynamic>;
  // 使用的Icon编号（为了处理该进阶下没有立绘的问题）
  final imageStandLength = (unit['ImageStand'] as List<dynamic>).length;
  final iconTable = [
    0,
    0,
    (imageStandLength > 1 ? 1 : 0),
    (imageStandLength > 2 ? 2 : 1),
    (imageStandLength > 2 ? 3 : 1)
  ];
  final imageTable = [
    0,
    0,
    imageStandLength > 1 ? 1 : 0,
    imageStandLength > 2 ? 2 : 1,
    imageStandLength > 2 ? (imageStandLength > 3 ? 3 : 2) : 1,
  ];
  final awakePattern = unit['_AwakePattern'];
  classes.forEach((v) {
    final type = v['Type'];
    final index = classTypeToIndex[type];
    final rare = unit['Rare'];
    // 计算最大等级
    v['MaxLevelUnit'] = maxLevelTable[index][rare];
    // 立绘index
    v['ImageStand'] = unit['ImageStand'][imageTable[index]];
    // 图标index
    v['IconIndex'] = iconTable[index];
    v['TypeText'] = classTextConst[index];
    // 是否渲染
    v['IsRenderer'] = true;
    if (rare > 10 && index < 2) {
      v['IsRenderer'] = false;
    }
    if (rare < 10 &&
        index > 2 &&
        awakePattern != 3 &&
        awakePattern + 2 != index) {
      v['IsRenderer'] = false;
    }
  });
  return unit;
}
