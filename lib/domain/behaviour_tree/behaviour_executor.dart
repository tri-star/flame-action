import '../../engine/entity/entity.dart';
import '../../engine/world.dart';

import 'behaviour_node.dart';
import 'behaviour_plan.dart';

class BehaviourExecutor {
  BehaviourNode _tree;

  BehaviourExecutor(BehaviourNode tree) : _tree = tree;

  BehaviourPlan decidePlan(WorldContext context, Entity entity) {
    BehaviourNode cursor = _tree;
    int limitter = 100;
    while (limitter-- > 0) {
      if (cursor.havePlan()) {
        return cursor.getPlan()..init();
      }
      cursor = cursor.getSatisfiedNode(context, entity);
      assert(cursor != null);
    }
  }
}
