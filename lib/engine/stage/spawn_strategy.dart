import '../camera.dart';
import '../world.dart';

abstract class SpawnStrategy {
  void update(WorldContext context, Camera camera);
}
