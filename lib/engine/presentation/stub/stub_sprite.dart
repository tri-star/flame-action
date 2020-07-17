import 'package:flame_action/engine/camera.dart';
import 'dart:ui';

import 'package:flame_action/engine/image/sprite.dart';

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
