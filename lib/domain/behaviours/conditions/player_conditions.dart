import '../../behaviour_tree/behaviour_condition.dart';
import '../../../engine/entity/entity.dart';
import '../../../engine/world.dart';

/// プレイヤーとのX軸の距離が一定以内であることの条件
class BehaviourConditionPlayerXIsLessThan extends BehaviourCondition {
  double distance;

  BehaviourConditionPlayerXIsLessThan({this.distance}) {
    assert(distance != null);
  }

  @override
  bool isSatisfied(WorldContext context, Entity entity) {
    Entity player = context.findTaggedFirst('player', useCache: true);
    return (player.getX() - entity.getX()).abs() <= distance;
  }
}

class BehaviourConditionPlayerXIsGreaterThan extends BehaviourCondition {
  double distance;

  BehaviourConditionPlayerXIsGreaterThan({this.distance}) {
    assert(distance != null);
  }

  @override
  bool isSatisfied(WorldContext context, Entity entity) {
    Entity player = context.findTaggedFirst('player', useCache: true);
    return (player.getX() - entity.getX()).abs() >= distance;
  }
}

class BehaviourConditionContactWithPlayer extends BehaviourCondition {
  double distance;

  BehaviourConditionContactWithPlayer({this.distance}) {
    assert(distance != null);
  }

  @override
  bool isSatisfied(WorldContext context, Entity entity) {
    Entity player = context.findTaggedFirst('player', useCache: true);

    bool isSatisfiedX = (player.getX() - entity.getX()).abs() <= distance;
    bool isSatisfiedZ = (player.getZ() - entity.getZ()).abs() <= distance;

    return isSatisfiedX && isSatisfiedZ;
  }
}
