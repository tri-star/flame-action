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
      enemy =
          Enemy(1, 'enemy', stubSpriteResolver, null, 100, x: 0, y: 0, z: 0);
      context = createContext(player, enemy);
    });

    test('プレイヤーが近くにいない場合、確率でニタニタと笑う', () {
      randomGenerator.setNumbers([
        1, // 「ニタニタ笑う」を選択させるためのランダム値
      ]);
      enemy.setLocation(x: 500);
      BehaviourPlan plan = executor.decidePlan(context, enemy);
      expect(plan != null, true, reason: 'プランがnullです。');
      expect(plan is SlingShotBehaviourPlanGlimming, true,
          reason: 'プランが"SlingShotBehaviourPlanGlimming"ではありません。');
    });

    group('プレイヤーが遠すぎる場合', () {
      test('確率でプレイヤーを狙う', () {
        randomGenerator.setNumbers([
          3, // 「プレイヤーが遠すぎる」を選択させるためのランダム値
          0, // 「プレイヤーを狙う」を選択させるためのランダム値
        ]);
        enemy.setLocation(x: 400);
        BehaviourPlan plan = executor.decidePlan(context, enemy);
        expect(plan != null, true, reason: 'プランがnullです。');
        expect(plan is SlingShotBehaviourPlanTargetting, true,
            reason: 'プランが"SlingShotBehaviourPlanTargetting"ではありません。');
      });

      test('確率でプレイヤーを追いかける', () {
        randomGenerator.setNumbers([
          3, // 「プレイヤーが遠すぎる」を選択させるためのランダム値
          1, // 「プレイヤーを追いかける」を選択させるためのランダム値
        ]);
        enemy.setLocation(x: 400);
        BehaviourPlan plan = executor.decidePlan(context, enemy);
        expect(plan != null, true, reason: 'プランがnullです。');
        expect(plan is SlingShotBehaviourPlanKeepDistance, true,
            reason: 'プランが"SlingShotBehaviourPlanKeepDistance"ではありません。');
      });
    });

    group('プレイヤーが射程内', () {
      test('確率でプレイヤーを狙う', () {
        randomGenerator.setNumbers([
          2, // 「プレイヤーが射程内」を選択させるためのランダム値
          2, // 「プレイヤーを狙う」を選択させるためのランダム値
        ]);
        enemy.setLocation(x: 399);
        BehaviourPlan plan = executor.decidePlan(context, enemy);
        expect(plan != null, true, reason: 'プランがnullです。');
        expect(plan is SlingShotBehaviourPlanTargetting, true,
            reason: 'プランが"SlingShotBehaviourPlanTargetting"ではありません。');
      });
    });

    group('プレイヤーが近すぎる', () {
      test('確率でプレイヤーを狙う', () {
        randomGenerator.setNumbers([
          2, // 「プレイヤーが近すぎる」を選択させるためのランダム値
        ]);
        enemy.setLocation(x: 199);
        BehaviourPlan plan = executor.decidePlan(context, enemy);
        expect(plan != null, true, reason: 'プランがnullです。');
        expect(plan is SlingShotBehaviourPlanKeepDistance, true,
            reason: 'プランが"SlingShotBehaviourPlanKeepDistance"ではありません。');
      });
    });
  });
}
