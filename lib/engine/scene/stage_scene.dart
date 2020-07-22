import 'package:flutter/foundation.dart';

import '../../engine/camera.dart';
import '../../engine/world.dart';
import '../../engine/presentation/wipe/wipe.dart';
import '../../engine/stage/stage.dart';
import 'scene.dart';

abstract class StageScene extends Scene {
  @protected
  Stage stage;

  StageScene(Stage stage, {Wipe enteringWipe, Wipe leavingWipe})
      : this.stage = stage,
        super(enteringWipe: enteringWipe, leavingWipe: leavingWipe) {
    assert(this.stage != null);
  }

  @override
  Future<void> update(WorldContext context, Camera camera) async {
    await super.update(context, camera);
    switch (state) {
      case SceneState.ACTIVE:
        stage.update(context, camera);
        break;
      default:
    }
  }
}
