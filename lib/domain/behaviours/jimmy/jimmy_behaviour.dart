import '../../behaviour_tree/behaviour_condition.dart';
import '../../behaviour_tree/behaviour_node.dart';
import '../../behaviour_tree/behaviour_tree_builder.dart';
import '../../behaviours/plan/common_plan.dart';
import '../conditions/player_conditions.dart';

/// ジミーの思考ルーチン
class JimmyBehaviourBuilder extends BehaviourTreeBuilder {
  @override
  BehaviourNode build() {
    return RootBehaviourNode([
      BehaviourNode(
        name: 'プレイヤーが遠い',
        weight: 2,
        condition: BehaviourCondition.not(
            BehaviourConditionContactWithPlayer(distance: 40)),
        nodes: [
          BehaviourNode(
            name: 'プレイヤーを追いかける',
            weight: 1,
            plan: CommonBehaviourPlanTargetting(),
          ),
        ],
      ),
      BehaviourNode(
        name: 'プレイヤーが射程内',
        weight: 3,
        condition: BehaviourConditionContactWithPlayer(distance: 40),
        nodes: [
          BehaviourNode(
            name: '攻撃する',
            weight: 2,
            plan: CommonBehaviourPlanAttack(),
          )
        ],
      ),
    ]);
  }
}
