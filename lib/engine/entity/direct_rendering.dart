import 'dart:ui';

import '../camera.dart';

/// Canvasに直接レンダリングするEntityが実装する
mixin DirectRendering {
  void renderDirect(Canvas canvas, Camera camera);
}
