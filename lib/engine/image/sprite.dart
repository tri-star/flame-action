import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flutter/foundation.dart';

import '../camera.dart';
import '../../domain/entity/entity.dart';

enum AnchorPoint {
  TOP_LEFT,
  TOP_CENTER,
  TOP_RIGHT,
  MIDDLE_LEFT,
  MIDDLE_CENTER,
  MIDDLE_RIGHT,
  BOTTOM_LEFT,
  BOTTOM_CENTER,
  BOTTOM_RIGHT,
}

/// 1枚絵の画像の表示に必要な情報を持ったオブジェクト
abstract class Sprite {
  double x = 0;
  double y = 0;
  double w = 0;
  double h = 0;
  Dimension dimension = Dimension.RIGHT;
  AnchorPoint anchor = AnchorPoint.TOP_LEFT;

  void render(Canvas canvas, Camera camera);
  Paint paint;

  @protected
  Position getOffset() {
    switch(anchor) {
      case AnchorPoint.TOP_LEFT: return Position(0, 0);
      case AnchorPoint.TOP_CENTER: return Position(-(w / 2), 0);
      case AnchorPoint.TOP_RIGHT: return Position(-w, 0);
      case AnchorPoint.MIDDLE_LEFT: return Position(0, -(h / 2));
      case AnchorPoint.MIDDLE_CENTER: return Position(-(w / 2), -(h / 2));
      case AnchorPoint.MIDDLE_RIGHT: return Position(-w, -(h / 2));
      case AnchorPoint.BOTTOM_LEFT: return Position(0, -h);
      case AnchorPoint.BOTTOM_CENTER: return Position(-(w / 2), -h);
      case AnchorPoint.BOTTOM_RIGHT: return Position(-w, -h);
    }
    throw new UnsupportedError('無効なAnchorPointが指定されました。: $anchor');
  }
}
