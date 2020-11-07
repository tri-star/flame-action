import 'dart:ui';

import '../../entity/ui/mask.dart';
import '../../engine/camera.dart';
import '../../engine/presentation/renderer.dart';

class MaskRenderer extends Renderer<Mask> {
  @override
  void render(Canvas canvas, Camera camera, Mask subject) {
    double zoom = camera.getZoom();

    canvas.drawRect(
        Rect.fromLTWH(
            camera.getRenderX(0, affectScroll: false),
            camera.getRenderY(0, affectScroll: false),
            camera.w * zoom,
            camera.h * zoom),
        Paint()..color = Color.fromRGBO(0, 0, 0, subject.opacity));
  }
}
