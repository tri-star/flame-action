import 'package:flame_action/engine/coordinates.dart';
import 'package:flame_action/engine/entity/figting_unit.dart';

import '../entity/entity.dart';

/// EntityとWorldの境界との位置調整を行うサービス
class BoundaryAdjustmentService {
  void adjust(Rect3d baseRect, Entity entity) {
    if (!(entity is FightingUnit)) {
      return;
    }

    Rect3d targetRect = entity.getRect();
    if (baseRect.isContain(targetRect)) {
      return;
    }
    Vector3d adjustment = baseRect.getOverflowAdjustment(targetRect);
    // Y 方向は今は別のサービスで調整するため制御しない
    adjustment.y = 0;
    entity.addAdjustment(adjustment);
  }
}
