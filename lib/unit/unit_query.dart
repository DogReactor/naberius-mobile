const UnitQuery = """
query unit(\$id: Int!) {
  card(CardID: \$id) {
    CardID
    Class {
      ClassInit {
        ...class
      }
      ClassEvo2b {
        ...class
      }
      ClassCC {
        ...class
      }
      ClassEvo {
        ...class
      }
      ClassEvo2a {
        ...class
      }
      ClassEvo2b {
        ...class
      }
    }
    SkillInit {
      ...skill
    }
    SkillCC {
      ...skill
    }
    SkillEvo {
      ...skill
    }
    Rare
    SellPrice
    BuildExp
    BonusType
    BonusNum
    BonusType2
    BonusNum2
    BonusType3
    BonusNum3
    CostModValue
    CostDecValue
    MaxHPMod
    AtkMod
    DefMod
    Illust
    MagicResistance
    AbilityInitInfo {
      ...ability
    }
    AbilityEvoInfo {
      ...ability
    }
    Kind
    Race
    Assign
    Identity
    Flavor
    Name
    ImageStand
    ImageCG
    NickName
    ConneName
    Talks
    _AwakePattern
    _TradePoint
  }
}

fragment skill on Skill {
  SkillID
  SkillName
  WaitTime
  ContTime
  ContTimeMax
  Power
  PowerMax
  LevelMax
  SkillType
  Text
  InfluenceConfig {
    Data_ID
    Type_Collision
    Type_CollisionState
    Type_ChangeFunction
    Data_Target
    Data_InfluenceType
    Description
    Data_MulValue
    Data_MulValue2
    Data_MulValue3
    Data_AddValue
    _HoldRatioUpperLimit
    _Expression
    _ExpressionActivate
  }
}

fragment class on Class {
  ClassID
  Name
  MaxLevel
  MaxLevelUnit
  Cost
  InitHP
  MaxHP
  AttackType
  InitAtk
  MaxAtk
  MaxTarget
  InitDef
  MaxDef
  AtkArea
  JobChange
  BlockNum
  AttackWait
  Explanation
  AwakeType1
  AwakeType2
  NickName
  ClassAbilityConfig1 {
    _ConfigID
    _InvokeType
    _TargetType
    _InfluenceType
    _Param1
    _Param2
    _Param3
    _Param4
    _Command
    _ActivateCommand
    Description
  }
  ClassAbilityPower1
  JobChangeMaterial {
    Name
  }
  Data_ExtraAwakeOrb {
    Name
  }
  BattleStyle{
    Type_BattleStyle
    _Param_01
    _Param_02
    _Range_01
    _Range_02
    _Range_03
    _Range_04
    _Range_05
  }
}

fragment ability on Ability {
  AbilityName
  AbilityPower
  AbilityType
  Text
  Config {
    _ConfigID
    _InvokeType
    _TargetType
    _InfluenceType
    _Param1
    _Param2
    _Param3
    _Param4
    _Command
    _ActivateCommand
    Description
  }
  AbilityID
}
""";
