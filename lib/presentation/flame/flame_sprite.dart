import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart' as Flame;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../engine/entity/entity.dart';
import '../../engine/camera.dart';
import '../../engine/coordinates.dart';
import '../../engine/image/sprite.dart';

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

  void render(Canvas canvas, Camera camera) {
    Paint paint = Paint();
    Vector3d anchorOffset = getOffsets();
    double localX = x + anchorOffset.x;
    double localY = y + anchorOffset.y + z;
    if (dimension == Dimension.LEFT) {
      Matrix4 cc = Matrix4.identity()
        ..translate(x + anchorOffset.x - (camera?.x ?? 0),
            y + anchorOffset.y + z - (camera?.y ?? 0))
        ..translate(w, 0)
        ..rotateY(180.0 * 3.14 / 180);

      paint.imageFilter = ImageFilter.matrix(cc.storage);
      localX = (camera?.x ?? 0);
      localY = (camera?.y ?? 0);
    }

    if (camera != null) {
      localX -= camera.x;
      localY -= camera.y;
    }

    //TODO: 画面外の場合描画する必要がない

    _flameSprite.renderPosition(canvas, Position(localX, localY),
        overridePaint: paint);
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
