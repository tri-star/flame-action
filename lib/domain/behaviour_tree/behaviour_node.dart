import 'package:flutter/foundation.dart';

import '../../engine/entity/entity.dart';
import '../../engine/world.dart';
import 'behaviour_task.dart';

/// ビヘイビアツリーのノード
abstract class BehaviourNode {
  /// 日本語のノードの名前。デバッグ用。
  @protected
  String name;

  @protected
  List<BehaviourNode> children;

  @protected
  List<BehaviourTask> tasks;

  String getName() => name;

  /// 前提条件を満たすかどうかを返す
  bool isSatisfied(WorldContext context, Entity entity);

  /// デバッグ用の日本語の説明。
  String get description;

  void appendChild(BehaviourNode node) {
    children.add(node);
  }

  void addNodes(List<BehaviourNode> nodes) {
    children.addAll(nodes);
  }

  void addTasks(List<BehaviourTask> tasks) {
    tasks.addAll(tasks);
  }

  bool haveTasks() => (tasks?.length ?? 0) > 0;

  BehaviourNode getSatisfiedNode(WorldContext context, Entity entity) {
    if (children == null) {
      return null;
    }
    return children
        .where((BehaviourNode node) => node.isSatisfied(context, entity))
        .first;
  }

  List<BehaviourTask> getTasks() => tasks;
}
