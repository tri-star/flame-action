import 'package:flame_action/engine/camera.dart';
import 'package:flame_action/engine/stage/spawn_strategy.dart';
import 'package:flame_action/engine/world.dart';
import 'package:flame_action/util/list.dart';
import 'package:flame_action/util/timer.dart';

/// 画面内の敵の数が一定数になるように敵を生成する
class ConstantAmountStrategy extends SpawnStrategy {
  TimeoutTimer _statTimer;
  int _enemyCount;
  int _threshold;

  ConstantAmountStrategy(int threshold)
      : _statTimer = TimeoutTimer(1.0),
        _enemyCount = 0,
        _threshold = threshold;

  @override
  void update(WorldContext context, Camera camera) {
    _statTimer.update();
    if (!_statTimer.isDone()) {
      return;
    }
    updateStat(context.entities);
    if (_enemyCount >= _threshold) {
      return;
    }

    int spawnDimension = context.randomGenerator.getIntBetween(0, 2);
    double spawnX = 0;
    double spawnZ = 0;
    if (camera.x >= 100 && spawnDimension == 1) {
      spawnX = context.randomGenerator
          .getIntBetween((camera.x - 100).toInt(), (camera.x - 50).toInt())
          .toDouble();
    } else if (2000 - (camera.x + camera.w) > 100) {
      spawnX = context.randomGenerator
          .getIntBetween((camera.x + camera.w + 50).toInt(),
              (camera.x + camera.w + 100).toInt())
          .toDouble();
    }
    // TODO: WorldのDepth, Heightを参照できるようにする
    spawnZ = context.randomGenerator.getIntBetween(0, 100).toDouble();

    // TODO: 敵の一覧を初期化時に渡して複数種類生成出来るようにする
    context
        .addUnit(context.entityFactory.create('enemy01', spawnX, 200, spawnZ));

    _statTimer.reset();
  }

  void updateStat(ZOrderedCollection entities) {
    _enemyCount = entities.where((entity) {
      return entity.getTags().contains('enemy');
    }).length;
  }
}
