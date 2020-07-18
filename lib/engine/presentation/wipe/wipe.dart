import 'dart:ui';

import '../../camera.dart';
import '../../world.dart';

abstract class Wipe {
  void update();

  void render(Canvas canvas, Camera camera);

  bool isDone();
}
