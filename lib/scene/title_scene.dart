import '../engine/entity/base_entity_factory.dart';
import '../engine/world.dart';
import '../engine/presentation/wipe/wipe.dart';
import '../engine/camera.dart';
import '../engine/scene.dart';

class TitleScene extends Scene {
  TitleScene(Wipe enteringWipe, Wipe leavingWipe)
      : super(enteringWipe: enteringWipe, leavingWipe: leavingWipe);

  @override
  Future<void> onInitialize(WorldContext context, Camera camera) async {
    BaseEntityFactory entityFactory = context.entityFactory;
    double gameW = camera.w;
    double gameH = camera.h;

    context.addHud(entityFactory.create('title', (gameW) / 2, gameH - 200, 0));
    context.addHud(
        entityFactory.create('start_button', (gameW) / 2, gameH - 100, 0));
  }
}
