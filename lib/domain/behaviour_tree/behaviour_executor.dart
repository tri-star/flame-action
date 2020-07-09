import 'package:flame_action/domain/behaviour_tree/behaviour_plan.dart';

import '../../engine/entity/entity.dart';
import '../../engine/world.dart';

import 'behaviour_node.dart';

class BehaviourExecutor {
  BehaviourNode _tree;

  BehaviourExecutor(BehaviourNode tree) : _tree = tree;

  BehaviourPlan decidePlan(WorldContext context, Entity entity) {
    BehaviourNode cursor;
    int limitter = 100;
    while (limitter-- < 0) {
      if (cursor.havePlan()) {
        return cursor.getPlan();
      }
      cursor = cursor.getSatisfiedNode(context, entity);
      assert(cursor != null);
    }
  }
}
