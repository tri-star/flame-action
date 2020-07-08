import '../../engine/entity/entity.dart';
import '../../engine/world.dart';

import 'behaviour_node.dart';

class BehaviourExecutor {
  BehaviourNode _tree;
  BehaviourNode _cursor;

  BehaviourExecutor(BehaviourNode tree) : _tree = tree {
    _cursor = _tree;
  }

  void update(WorldContext context, Entity entity) {
    if (_cursor.haveTasks()) {
      _executetasks(context, entity);
      return;
    }
    _cursor = _cursor.getSatisfiedNode(context, entity);
    assert(_cursor != null);
  }

  /// ノードに定義されているタスクの一覧を実行して、
  /// カーソルをツリーの先頭に戻す
  void _executetasks(WorldContext context, Entity entity) {
    _cursor.getTasks().forEach((task) {
      task.execute(context, entity);
    });
    _cursor = _tree;
  }
}
