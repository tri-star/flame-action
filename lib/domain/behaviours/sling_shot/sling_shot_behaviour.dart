import 'package:flame_action/engine/world.dart';

import 'package:flame_action/engine/entity/entity.dart';

import '../../behaviour_tree/behaviour_node.dart';
import '../../behaviour_tree/behaviour_tree_builder.dart';

/// パチンコ小僧の思考ルーチン
class SlingShotBehaviourBuilder extends BehaviourTreeBuilder {
  @override
  BehaviourNode build() {
    return RootBehaviourNode(
        [SlingShotBehaviourGlimming(), SlingShotBehaviourAttack()]);
  }
}

class SlingShotBehaviourGlimming extends BehaviourNode {
  @override
  String get name => 'ニタニタ笑う';

  @override
  String get description => '一定距離以内にプレイヤーがいない場合';

  @override
  bool isSatisfied(WorldContext context, Entity entity) {
    Entity player = context.findTaggedFirst('player', useCache: true);
    return (player.getX() - entity.getX()).abs() > 200;
  }

  @override
  int get weight => 40;
}

class SlingShotBehaviourAttack extends BehaviourNode {
  @override
  String get name => '攻撃モード';

  @override
  String get description => '一定距離以内にプレイヤーがいる場合';

  @override
  bool isSatisfied(WorldContext context, Entity entity) {
    Entity player = context.findTaggedFirst('player', useCache: true);
    return (player.getX() - entity.getX()).abs() <= 200;
  }

  @override
  int get weight => 60;
}
