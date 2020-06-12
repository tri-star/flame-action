import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart' as Flame;
import 'package:flame_action/domain/animation/sprite.dart';
import 'package:flutter/rendering.dart';

import '../../domain/entity/entity.dart';

class FlameSprite extends Sprite {

  Flame.Sprite _flameSprite;

  FlameSprite(Flame.Sprite flameSprite, {double x, double y, Dimension dimension}): 
    _flameSprite = flameSprite {
    this.x = x;
    this.y = y;
    this.dimension = dimension;
  }

  double get w => _flameSprite.size.x;
  double get h => _flameSprite.size.y;

  void render(Canvas canvas) {

    Paint paint = Paint();
    double localX = x;
    double localY = y;
    if(dimension == Dimension.LEFT) {
      Matrix4 cc = Matrix4.identity()
        ..translate(x, y)
        ..translate(w, 0)
        ..rotateY(180.0 * 3.14 / 180);

      paint.imageFilter = ImageFilter.matrix(cc.storage);
      localX = 0;
      localY = 0;
    }
    _flameSprite.renderPosition(canvas, Position(localX, localY), overridePaint: paint);
  }
}
