import 'package:flutter/foundation.dart';

import '../../engine/entity/entity.dart';
import '../../engine/world.dart';

///前提条件を定義するクラス
abstract class BehaviourCondition {
  /// 前提条件を満たすかどうかを返す
  bool isSatisfied(WorldContext context, Entity entity);

  BehaviourCondition();

  factory BehaviourCondition.and(List<BehaviourCondition> group) {
    return BehaviourConditionAnd(group);
  }

  factory BehaviourCondition.or(List<BehaviourCondition> group) {
    return BehaviourConditionOr(group);
  }

  factory BehaviourCondition.not(BehaviourCondition condition) {
    return BehaviourConditionNot(condition);
  }
}

/// リストで渡した条件全てがtrueかどうかを返す
class BehaviourConditionAnd extends BehaviourCondition {
  @protected
  List<BehaviourCondition> group;

  BehaviourConditionAnd(this.group);

  @override
  bool isSatisfied(WorldContext context, Entity entity) {
    bool isAllSatisfied = true;
    group.forEach((condition) {
      if (!isAllSatisfied) {
        return;
      }
      if (!condition.isSatisfied(context, entity)) {
        isAllSatisfied = false;
      }
    });
    return isAllSatisfied;
  }
}

/// リストで渡した条件のどれか一つがtrueかを返す
class BehaviourConditionOr extends BehaviourCondition {
  @protected
  List<BehaviourCondition> group;

  BehaviourConditionOr(this.group);

  @override
  bool isSatisfied(WorldContext context, Entity entity) {
    bool isSatisfiedAny = false;
    group.forEach((condition) {
      if (isSatisfiedAny) {
        return;
      }
      if (condition.isSatisfied(context, entity)) {
        isSatisfiedAny = true;
      }
    });
    return isSatisfiedAny;
  }
}

/// 渡した条件がfalseだった場合にtrueを返す
class BehaviourConditionNot extends BehaviourCondition {
  @protected
  BehaviourCondition condition;

  BehaviourConditionNot(this.condition);

  @override
  bool isSatisfied(WorldContext context, Entity entity) {
    return !condition.isSatisfied(context, entity);
  }
}
