import 'package:flutter/foundation.dart';

import '../../engine/entity/entity.dart';
import '../../engine/world.dart';
import 'behaviour_condition.dart';
import 'behaviour_plan.dart';

/// ビヘイビアツリーのノード
///
/// 行動プランを決定する際、このツリーを辿りながらプランを決定する。
/// プランの決定は以下のように行われる
/// 1. 自身が持っている全ノードの中から、条件を満たすノードを取得する
/// 2. 条件を満たすノードが複数存在する場合、weight(重み)を意識してランダムに1つ選択する
/// 3. 選ばれたノードがノードの一覧を持っている場合、(1)を再び繰り返してツリーを下る
/// 4. ノードがプランを持っている場合、そのプランを採用する
///
/// プランは「X,Y,Zまで歩く」、「攻撃を実行する」ような粒度の行動プランで、
/// プランが終了すると再びビヘイビアツリーを使って次のプランを決定する。
class BehaviourNode {
  ///ノードの名前(日本語。デバッグや定義の可読性のため)。
  @protected
  String name;

  /// 前提条件
  @protected
  BehaviourCondition condition;

  /// 自身の重み付け
  /// (値が高いほど、同じ階層の他のノードよりも選ばれる可能性が高くなる)
  @protected
  int weight;

  /// 選択可能なノードの一覧
  @protected
  List<BehaviourNode> children;

  /// プラン
  @protected
  BehaviourPlan plan;

  @mustCallSuper
  BehaviourNode(
      {this.name = '',
      this.condition,
      this.weight = 1,
      List<BehaviourNode> nodes,
      this.plan})
      : children = nodes ?? List<BehaviourNode>();

  /// 前提条件を満たすかどうかを返す
  /// conditionが指定されていない場合は常にtrueを返す
  bool isSatisfied(WorldContext context, Entity entity) {
    return condition?.isSatisfied(context, entity) ?? true;
  }

  String getName() => name;

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
  RootBehaviourNode(List<BehaviourNode> nodes)
      : super(name: 'ルートノード', nodes: nodes);
}
