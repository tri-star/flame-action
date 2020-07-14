import 'package:flame_action/domain/behaviour_tree/behaviour_condition.dart';

import '../../behaviours/conditions/player_conditions.dart';
import '../../behaviour_tree/behaviour_node.dart';
import '../../behaviour_tree/behaviour_tree_builder.dart';
import 'sling_shot_plan.dart';

/// パチンコ小僧の思考ルーチン
class SlingShotBehaviourBuilder extends BehaviourTreeBuilder {
  @override
  BehaviourNode build() {
    return RootBehaviourNode([
      BehaviourNode(
          name: 'ニタニタ笑う', weight: 1, plan: SlingShotBehaviourPlanGlimming()),
      BehaviourNode(
        name: 'プレイヤーが遠すぎる',
        weight: 2,
        condition: BehaviourConditionPlayerXIsGreaterThan(distance: 400),
        nodes: [
          BehaviourNode(
            name: 'プレイヤーを狙う',
            weight: 1,
            plan: SlingShotBehaviourPlanTargetting(),
          ),
          BehaviourNode(
            name: 'プレイヤーを追いかける',
            weight: 2,
            plan: SlingShotBehaviourPlanKeepDistance(400),
          ),
        ],
      ),
      BehaviourNode(
        name: 'プレイヤーが射程内',
        weight: 3,
        condition: BehaviourConditionPlayerXIsLessThan(distance: 400),
        nodes: [
          BehaviourNode(
            name: 'プレイヤーを狙う',
            weight: 3,
            plan: SlingShotBehaviourPlanTargetting(),
          ),
          BehaviourNode(
            name: '攻撃する',
            weight: 2,
            plan: SlingShotBehaviourPlanAttack(),
          ),
          BehaviourNode(
            name: 'プレイヤーから離れる',
            condition: BehaviourConditionPlayerXIsLessThan(distance: 200),
            weight: 3,
            plan: SlingShotBehaviourPlanKeepDistance(200),
          )
        ],
      ),
    ]);
  }
}
