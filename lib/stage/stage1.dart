import 'package:flame_action/engine/global_event.dart';
import 'package:flame_action/engine/stage/stage.dart';

import '../engine/camera.dart';
import '../engine/stage/constant_amount_strategy.dart';
import '../engine/stage/spawn_strategy.dart';
import '../engine/world.dart';
import 'action_stage.dart';

class Stage1 extends ActionStage {
  SpawnStrategy _spawnStrategy;

  final int _targetKillCount = 10;

  Stage1() : _spawnStrategy = ConstantAmountStrategy(3);

  @override
  void update(WorldContext context, Camera camera) {
    if (state == StageState.STATE_CLEAR) {
      return;
    }

    if (killCount >= _targetKillCount) {
      state = StageState.STATE_CLEAR;
      GlobalEventBus.instance().notify(context, GlobalEvent('stage_clear'));
    }

    _spawnStrategy.update(context, camera);
  }
}
