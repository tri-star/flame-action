import 'dart:ui';

import '../camera.dart';

abstract class Renderer<T> {
  void render(Canvas canvas, Camera camera, T subject);
}
