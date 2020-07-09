import 'package:flutter/foundation.dart';

import '../../engine/entity/entity.dart';
import '../../engine/world.dart';
import 'behaviour_plan.dart';

/// ビヘイビアツリーのノード
abstract class BehaviourNode {
  @protected
  List<BehaviourNode> children;

  @protected
  BehaviourPlan plan;

  @protected
  int weight;

  @mustCallSuper
  BehaviourNode({this.weight = 10}) : children = List<BehaviourNode>();

  /// 前提条件を満たすかどうかを返す
  bool isSatisfied(WorldContext context, Entity entity);

  /// ノードの名前
  String get name;

  /// デバッグ用の日本語の説明。
  String get description;

  void appendChild(BehaviourNode node) {
    children.add(node);
  }

  void addNodes(List<BehaviourNode> nodes) {
    children.addAll(nodes);
  }

  void setPlan(BehaviourPlan plan) {
    this.plan = plan;
  }

  bool havePlan() => plan != null;

  /// ノード一覧の中から、条件を満たすノードを1つだけ返す
  /// 条件を満たすものが複数存在した場合、weightに応じてランダムに選択して返す
  BehaviourNode getSatisfiedNode(WorldContext context, Entity entity) {
    if (children == null) {
      return null;
    }
    List<BehaviourNode> nodes = children
        .where((BehaviourNode node) => node.isSatisfied(context, entity))
        .toList();

    int weightTotal = 0;
    nodes.forEach((node) {
      weightTotal += node.getWeight();
    });

    int randomValue = context.randomGenerator.getIntBetween(0, weightTotal);
    int weightSum = 0;

    BehaviourNode selectedNode;
    nodes.forEach((node) {
      if (randomValue > weightSum &&
          randomValue <= (weightSum + node.getWeight())) {
        selectedNode = node;
      }
      weightSum += node.getWeight();
    });

    return selectedNode;
  }

  BehaviourPlan getPlan() => plan;

  int getWeight() => weight;
}

class RootBehaviourNode extends BehaviourNode {
  RootBehaviourNode(List<BehaviourNode> nodes) : super() {
    nodes.forEach((node) {
      this.children.add(node);
    });
  }

  /// 前提条件を満たすかどうかを返す
  bool isSatisfied(WorldContext context, Entity entity) {
    return true;
  }

  @override
  String get name => 'ルートノード';

  /// デバッグ用の日本語の説明。
  String get description => 'ルートノード';
}
