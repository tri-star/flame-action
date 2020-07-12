import 'package:flame_action/domain/behaviour_tree/behaviour_plan.dart';
import 'package:flame_action/domain/behaviours/sling_shot/sling_shot_plan.dart';
import 'package:flame_action/engine/entity/entity.dart';
import 'package:flame_action/engine/presentation/stub/stub_sprite_resolver.dart';
import 'package:flame_action/engine/world.dart';
import 'package:flame_action/entity/enemy.dart';
import 'package:flame_action/entity/player.dart';
import 'package:flame_action/util/ticker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../util/world_context.dart';

WorldContext createContext(Player player, Entity enemy) {
  WorldContext context = WorldContextUtil.create();
  context.entities.add(player);
  context.entities.add(enemy);
  return context;
}

void main() {
  group('SlingShotBehaviourPlanGlimming', () {
    WorldContext context;
    StubSpriteResolver stubSpriteResolver;
    Entity player;
    Entity enemy;

    setUp(() {
      stubSpriteResolver = StubSpriteResolver(w: 60, h: 100, d: 20);
      player = Player(0, stubSpriteResolver, x: 0, y: 0, z: 0);
      enemy =
          Enemy(1, 'enemy', stubSpriteResolver, null, 100, x: 0, y: 0, z: 0);
      context = createContext(player, enemy);
    });

    test('一定時間ニタニタして終了すること', () {
      BehaviourPlan plan = SlingShotBehaviourPlanGlimming();
      Ticker ticker = Ticker();
      enemy.setState('walk');
      ticker.tick(0.5, () {
        plan.execute(context, enemy);
      });
      expect(enemy.getState(), 'neutral', reason: '状態がneutralになっていません。');
      expect(plan.isDone(), false, reason: 'タイマーの完了前にプランが終了しています');
      ticker.tick(0.2, () {
        plan.execute(context, enemy);
      });
      expect(plan.isDone(), true, reason: '時間が経過してもプランが完了していません');
    });

    test('neutralに遷移不可な状態から無理やり状態遷移しないこと', () {
      BehaviourPlan plan = SlingShotBehaviourPlanGlimming();
      Ticker ticker = Ticker();
      enemy.setState('attack');
      ticker.tick(0.5, () {
        plan.execute(context, enemy);
      });
      expect(enemy.getState(), 'attack', reason: '状態がneutralに変更されています');
      expect(plan.isDone(), false, reason: 'タイマーの完了前にプランが終了しています');
    });
  });

  group('SlingShotBehaviourPlanKeepDistance', () {
    WorldContext context;
    StubSpriteResolver stubSpriteResolver;
    Entity player;
    Entity enemy;

    setUp(() {
      stubSpriteResolver = StubSpriteResolver(w: 60, h: 100, d: 20);
      player = Player(0, stubSpriteResolver, x: 0, y: 0, z: 0);
      enemy =
          Enemy(1, 'enemy', stubSpriteResolver, null, 100, x: 0, y: 0, z: 0);
      context = createContext(player, enemy);
    });

    group('初期状態でプレイヤーとの距離が近い(距離を取るモード)', () {
      test('プレイヤーが左にいる場合、右に逃げること', () {
        player.setLocation(x: 0);
        enemy.setLocation(x: 100);
        BehaviourPlan plan = SlingShotBehaviourPlanKeepDistance(200);
        Ticker ticker = Ticker();
        plan.execute(context, enemy);
        plan.execute(context, enemy);
        enemy.update(context);

        // TODO: 状態もテストしたいが、今はStubSpriteResolverでループするアニメーションを指定できないためテスト出来ない
        // expect(enemy.getState(), 'walk', reason: '状態がwalkになっていません。');
        expect(enemy.getX(), 102, reason: '想定する方向に移動していません');
        expect(plan.isDone(), false, reason: 'タイマーの完了前にプランが終了しています');
        ticker.tick(2.0, () {
          plan.execute(context, enemy);
        });
        expect(plan.isDone(), true, reason: '時間が経過してもプランが完了していません');
      });

      test('プレイヤーが右にいる場合、左に逃げること', () {
        player.setLocation(x: 200);
        enemy.setLocation(x: 100);
        BehaviourPlan plan = SlingShotBehaviourPlanKeepDistance(200);
        Ticker ticker = Ticker();
        plan.execute(context, enemy);
        plan.execute(context, enemy);
        enemy.update(context);

        expect(enemy.getX(), 98, reason: '想定する方向に移動していません');
        expect(plan.isDone(), false, reason: 'タイマーの完了前にプランが終了しています');
        ticker.tick(2.0, () {
          plan.execute(context, enemy);
        });
        expect(plan.isDone(), true, reason: '時間が経過してもプランが完了していません');
      });
    });

    group('初期状態でプレイヤーとの距離が遠い(追いかけるモード)', () {
      test('プレイヤーが左にいる場合、左に動くこと', () {
        player.setLocation(x: 0);
        enemy.setLocation(x: 300);
        BehaviourPlan plan = SlingShotBehaviourPlanKeepDistance(200);
        plan.execute(context, enemy);
        plan.execute(context, enemy);
        enemy.update(context);

        expect(enemy.getX(), 298, reason: '想定する方向に移動していません');
        expect(plan.isDone(), false, reason: 'タイマーの完了前にプランが終了しています');
      });

      test('プレイヤーが右にいる場合、右に動くこと', () {
        player.setLocation(x: 400);
        enemy.setLocation(x: 100);
        BehaviourPlan plan = SlingShotBehaviourPlanKeepDistance(200);
        plan.execute(context, enemy);
        plan.execute(context, enemy);
        enemy.update(context);

        expect(enemy.getX(), 102, reason: '想定する方向に移動していません');
      });
    });
  });
}
