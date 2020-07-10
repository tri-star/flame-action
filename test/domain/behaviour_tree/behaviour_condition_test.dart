import 'package:flame_action/domain/behaviour_tree/behaviour_condition.dart';
import 'package:flame_action/engine/world.dart';
import 'package:flame_action/engine/entity/entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/world_context.dart';

class TestBehaviourCondition extends BehaviourCondition {
  bool satisfied;
  TestBehaviourCondition(this.satisfied);

  @override
  bool isSatisfied(WorldContext context, Entity entity) {
    return satisfied;
  }
}

void main() {
  group('BehaviourConditionAnd', () {
    test('全部trueを返す', () {
      BehaviourCondition condition = BehaviourCondition.and([
        TestBehaviourCondition(true),
        TestBehaviourCondition(true),
      ]);
      WorldContext context = WorldContextUtil.create();

      expect(condition.isSatisfied(context, null), true);
    });

    test('1つfalseを返す', () {
      BehaviourCondition condition = BehaviourCondition.and([
        TestBehaviourCondition(true),
        TestBehaviourCondition(false),
        TestBehaviourCondition(true),
      ]);
      WorldContext context = WorldContextUtil.create();

      expect(condition.isSatisfied(context, null), false);
    });
  });

  group('BehaviourConditionOr', () {
    test('全部falseを返す', () {
      BehaviourCondition condition = BehaviourCondition.or([
        TestBehaviourCondition(false),
        TestBehaviourCondition(false),
      ]);
      WorldContext context = WorldContextUtil.create();

      expect(condition.isSatisfied(context, null), false);
    });

    test('1つtrueを返す', () {
      BehaviourCondition condition = BehaviourCondition.or([
        TestBehaviourCondition(false),
        TestBehaviourCondition(true),
        TestBehaviourCondition(false),
      ]);
      WorldContext context = WorldContextUtil.create();

      expect(condition.isSatisfied(context, null), true);
    });
  });

  group('BehaviourConditionNot', () {
    test('falseの時はtrueを返す', () {
      BehaviourCondition condition =
          BehaviourCondition.not(TestBehaviourCondition(false));
      WorldContext context = WorldContextUtil.create();

      expect(condition.isSatisfied(context, null), true);
    });

    test('trueの時はfalseを返す', () {
      BehaviourCondition condition =
          BehaviourCondition.not(TestBehaviourCondition(true));
      WorldContext context = WorldContextUtil.create();

      expect(condition.isSatisfied(context, null), false);
    });
  });

  group('組み合わせ', () {
    test('ANDとORの組み合わせ', () {
      BehaviourCondition condition =
          BehaviourCondition.not(BehaviourCondition.and([
        TestBehaviourCondition(true),
        TestBehaviourCondition(false),
      ]));
      WorldContext context = WorldContextUtil.create();

      expect(condition.isSatisfied(context, null), true);
    });
  });
}
