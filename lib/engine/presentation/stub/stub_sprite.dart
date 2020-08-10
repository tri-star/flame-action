import 'dart:ui';

import '../../image/sprite.dart';
import '../../camera.dart';

class StubSprite extends Sprite {
  StubSprite(double x, double y, double z, double w, double h, double d) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
    this.h = h;
    this.d = d;
    this.zAnchor = ZAnchorPoint.FRONT;
  }

  @override
  void render(Canvas canvas, Camera camera, {bool affectScroll = true}) {}
}
