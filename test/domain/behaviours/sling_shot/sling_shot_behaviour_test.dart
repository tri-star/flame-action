import 'package:flame_action/domain/behaviour_tree/behaviour_executor.dart';
import 'package:flame_action/domain/behaviour_tree/behaviour_node.dart';
import 'package:flame_action/domain/behaviour_tree/behaviour_plan.dart';
import 'package:flame_action/domain/behaviours/sling_shot/sling_shot_behaviour.dart';
import 'package:flame_action/domain/behaviours/sling_shot/sling_shot_plan.dart';
import 'package:flame_action/engine/entity/entity.dart';
import 'package:flame_action/engine/presentation/stub/stub_sprite_resolver.dart';
import 'package:flame_action/engine/random/stub_random_generator.dart';
import 'package:flame_action/engine/world.dart';
import 'package:flame_action/entity/enemy.dart';
import 'package:flame_action/entity/player.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../util/world_context.dart';

SlingShotBehaviourBuilder builder = SlingShotBehaviourBuilder();
BehaviourNode tree = builder.build();
BehaviourExecutor executor = BehaviourExecutor(tree);
StubRandomGenerator randomGenerator = StubRandomGenerator();

WorldContext createContext(Player player, Entity enemy) {
  WorldContext context =
      WorldContextUtil.create(randomGenerator: randomGenerator);
  context.entities.add(player);
  context.entities.add(enemy);
  return context;
}

void main() {
  group('SlingShotBehaviourBuilder', () {
    WorldContext context;
    Player player;
    Entity enemy;

    setUp(() {
      StubSpriteResolver stubSpriteResolver =
          StubSpriteResolver(w: 60, h: 100, d: 20);
      player = Player(0, stubSpriteResolver, x: 0, y: 0, z: 0);
      enemy = Enemy(1, 'enemy', stubSpriteResolver, 100, x: 0, y: 0, z: 0);
      context = createContext(player, enemy);
    });

    test('プレイヤーが近くにいなければ常にニタニタと笑っている', () {
      randomGenerator.setNumbers([1]);
      enemy.setLocation(x: 200);
      BehaviourPlan plan = executor.decidePlan(context, enemy);
      expect(plan != null, true, reason: 'プランがnullです。');
      expect(plan is SlingShotBehaviourPlanGlimming, true,
          reason: 'プランが"SlingShotBehaviourPlanGlimming"ではありません。');
    });

    test('プレイヤーが近くにいる場合、確率で「距離を取る」プランを選択する', () {
      randomGenerator.setNumbers([
        2, //「プレイヤーが接近」を選択
        1, // 「距離を取る」を選択
      ]);
      enemy.setLocation(x: 199);
      BehaviourPlan plan = executor.decidePlan(context, enemy);
      expect(plan != null, true, reason: 'プランがnullです。');
      expect(plan is SlingShotBehaviourPlanKeepDistance, true,
          reason: 'プランが"SlingShotBehaviourPlanKeepDistance"ではありません。');
    });

    test('プレイヤーが近くにいる場合、確率で「プレイヤーを狙う」プランを選択する', () {
      randomGenerator.setNumbers([
        2, //「プレイヤーが接近」を選択
        2, // 「プレイヤーを狙う」を選択
      ]);
      enemy.setLocation(x: 199);
      BehaviourPlan plan = executor.decidePlan(context, enemy);
      expect(plan != null, true, reason: 'プランがnullです。');
      expect(plan is SlingShotBehaviourPlanTargetting, true,
          reason: 'プランが"SlingShotBehaviourPlanTargetting"ではありません。');
    });
  });
}
