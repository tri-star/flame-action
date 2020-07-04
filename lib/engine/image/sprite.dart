import 'dart:ui';

import '../camera.dart';
import '../entity/entity.dart';
import '../coordinates.dart';

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

enum ZAnchorPoint {
  FRONT,
  CENTER,
  REAR,
}

/// 1枚絵の画像の表示に必要な情報を持ったオブジェクト
abstract class Sprite {
  double x = 0;
  double y = 0;
  double z = 0;
  double w = 0;
  double h = 0;
  double d = 1;
  Dimension dimension = Dimension.RIGHT;
  AnchorPoint anchor = AnchorPoint.TOP_LEFT;
  ZAnchorPoint zAnchor = ZAnchorPoint.CENTER;

  void render(Canvas canvas, Camera camera);
  Paint paint;

  Vector3d getOffsets() {
    double zOffset = 0;
    switch (zAnchor) {
      case ZAnchorPoint.FRONT:
        zOffset = 0;
        break;
      case ZAnchorPoint.CENTER:
        zOffset = -(d / 2);
        break;
      case ZAnchorPoint.REAR:
        zOffset = -d;
        break;
    }

    switch (anchor) {
      case AnchorPoint.TOP_LEFT:
        return Vector3d(0, 0, zOffset);
      case AnchorPoint.TOP_CENTER:
        return Vector3d(-(w / 2), 0, zOffset);
      case AnchorPoint.TOP_RIGHT:
        return Vector3d(-w, 0, zOffset);
      case AnchorPoint.MIDDLE_LEFT:
        return Vector3d(0, -(h / 2), zOffset);
      case AnchorPoint.MIDDLE_CENTER:
        return Vector3d(-(w / 2), -(h / 2), zOffset);
      case AnchorPoint.MIDDLE_RIGHT:
        return Vector3d(-w, -(h / 2), zOffset);
      case AnchorPoint.BOTTOM_LEFT:
        return Vector3d(0, -h, zOffset);
      case AnchorPoint.BOTTOM_CENTER:
        return Vector3d(-(w / 2), -h, zOffset);
      case AnchorPoint.BOTTOM_RIGHT:
        return Vector3d(-w, -h, zOffset);
    }
    throw new UnsupportedError('無効なAnchorPointが指定されました。: $anchor');
  }
}
