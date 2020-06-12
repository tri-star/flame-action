import 'dart:ui';

import 'package:flame_action/domain/entity/entity.dart';

/// 1枚絵の画像の表示に必要な情報を持ったオブジェクト
abstract class Sprite {
  double x = 0;
  double y = 0;
  double w = 0;
  double h = 0;
  Dimension dimension = Dimension.RIGHT;

  void render(Canvas canvas);
  Paint paint;
}
