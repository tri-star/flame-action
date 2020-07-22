import '../engine/camera.dart';
import '../engine/stage/stage.dart';
import '../engine/stage/constant_amount_strategy.dart';
import '../engine/stage/spawn_strategy.dart';
import '../engine/world.dart';

class Stage1 extends Stage {
  SpawnStrategy _spawnStrategy;

  Stage1() : _spawnStrategy = ConstantAmountStrategy(3);

  @override
  void update(WorldContext context, Camera camera) {
    _spawnStrategy.update(context, camera);
  }
}
