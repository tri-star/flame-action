import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart' as Flame;
import 'package:flutter/rendering.dart';

import '../../domain/entity/entity.dart';
import '../../engine/camera.dart';
import '../../engine/image/sprite.dart';

class FlameSprite extends Sprite {

  Flame.Sprite _flameSprite;

  FlameSprite(Flame.Sprite flameSprite, {double x, double y, Dimension dimension}): 
    _flameSprite = flameSprite {
    this.x = x ?? 0;
    this.y = y ?? 0;
    this.dimension = dimension;
  }

  double get w => _flameSprite.loaded() ? _flameSprite.size?.x : 0;
  double get h => _flameSprite.loaded() ? _flameSprite.size?.y : 0;

  void render(Canvas canvas, Camera camera) {

    Paint paint = Paint();
    Position anchorOffset = getOffset();
    double localX = x + anchorOffset.x;
    double localY = y + anchorOffset.y;
    if(dimension == Dimension.LEFT) {
      Matrix4 cc = Matrix4.identity()
        ..translate(x + anchorOffset.x - (camera?.x ?? 0), y + anchorOffset.y - (camera?.y ?? 0))
        ..translate(w, 0)
        ..rotateY(180.0 * 3.14 / 180);

      paint.imageFilter = ImageFilter.matrix(cc.storage);
      localX = (camera?.x ?? 0);
      localY = (camera?.y ?? 0);
    }

    if(camera != null) {
      localX -= camera.x;
      localY -= camera.y;
    }

    //TODO: 画面外の場合描画する必要がない

    _flameSprite.renderPosition(canvas, Position(localX, localY), overridePaint: paint);
  }
}
