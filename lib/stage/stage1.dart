import '../engine/camera.dart';
import '../engine/stage/constant_amount_strategy.dart';
import '../engine/stage/spawn_strategy.dart';
import '../engine/world.dart';
import 'action_stage.dart';

class Stage1 extends ActionStage {
  SpawnStrategy _spawnStrategy;

  Stage1() : _spawnStrategy = ConstantAmountStrategy(3);

  @override
  void update(WorldContext context, Camera camera) {
    _spawnStrategy.update(context, camera);
  }
}
