const UnitQuery = """
query unit(\$id: Int!) {
   Card(CardID: \$id) {
    CardID
    Classes {
			...class
    }
    Skills {
      Type
      Skills{
        ...skill
      }
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
    IllustName
    MagicResistance
    Abilities {
      ...ability
    }
    Kind
    RaceName
    AssignName
    Identity
    Flavor
    Name
    ImageStand
    ImageCG
    NickNames
    ConneName
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
  Configs {
    Data_ID
    Type_Collision
    Type_CollisionState
    Type_ChangeFunction
    Data_Target
    Data_InfluenceType
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
  NickNames
  Type
  ClassAbilityConfigs {
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
  }
  ClassAbilityPower1
  JobChangeMaterials {
    Name
  }
  Data_ExtraAwakeOrbs {
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
  Type
  Configs {
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
  }
  AbilityID
}
""";
