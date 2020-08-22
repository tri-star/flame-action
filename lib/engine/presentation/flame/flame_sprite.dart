import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart' as Flame;
import 'package:flutter/rendering.dart';

import '../../entity/entity.dart';
import '../../camera.dart';
import '../../coordinates.dart';
import '../../image/sprite.dart';

class FlameSprite extends Sprite {
  Flame.Sprite _flameSprite;

  FlameSprite(Flame.Sprite flameSprite,
      {double x,
      double y,
      double z,
      double w,
      double h,
      double d,
      Dimension dimension})
      : _flameSprite = flameSprite {
    this.x = x ?? 0;
    this.y = y ?? 0;
    this.z = z ?? 0;
    this.w = w ?? 1;
    this.h = h ?? 1;
    this.d = d ?? 1;
    this.dimension = dimension;
  }

  void render(Canvas canvas, Camera camera,
      {bool affectScroll = true, bool convertZtoY = false}) {
    Paint paint = this.paint ?? Paint();
    Vector3d anchorOffset = getOffsets();
    double localX = x + anchorOffset.x;
    double localY = y + anchorOffset.y;
    if (convertZtoY) {
      localY += z;
    }
    double zoom = camera.getZoom();
    if (dimension == Dimension.LEFT) {
      Matrix4 cc = Matrix4.identity()
        ..translate(
            camera.getRenderX(x + anchorOffset.x, affectScroll: affectScroll),
            camera.getRenderY(y + anchorOffset.y + (convertZtoY ? z : 0),
                affectScroll: affectScroll))
        ..translate(w * zoom, 0)
        ..rotateY((180.0 * 3.14 / 180));

      paint.imageFilter = ImageFilter.matrix(cc.storage);
      localX = 0;
      localY = 0;
    } else {
      localX = camera.getRenderX(localX, affectScroll: affectScroll);
      localY = camera.getRenderY(localY, affectScroll: affectScroll);
    }

    //TODO: 画面外の場合描画する必要がない

    _flameSprite.renderScaled(canvas, Position(localX, localY),
        scale: camera.getZoom(), overridePaint: paint);
/*
    canvas.drawRect(
        Rect.fromLTWH(localX, localY - anchorOffset.z, w, h),
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.greenAccent);
    canvas.drawRect(
        Rect.fromLTWH(localX, localY + anchorOffset.z, w, h),
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.greenAccent);
*/
  }
}
