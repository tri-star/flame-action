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
          name: 'プレイヤーが接近',
          condition: BehaviourConditionPlayerXIsLessThan(distance: 200),
          weight: 3,
          nodes: [
            BehaviourNode(
              name: '距離を取る',
              weight: 1,
              plan: SlingShotBehaviourPlanKeepDistance(300),
            ),
            BehaviourNode(
              name: 'プレイヤーを狙う',
              weight: 3,
              plan: SlingShotBehaviourPlanTargetting(),
            ),
          ])
    ]);
  }
}
