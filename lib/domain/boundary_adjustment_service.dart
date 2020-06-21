import 'package:flame_action/engine/coordinates.dart';

import 'entity/entity.dart';

/// EntityとWorldの境界との位置調整を行うサービス
class BoundaryAdjustmentService {

  void adjust(Rect3d baseRect, Entity entity) {
    Rect3d targetRect = entity.getRect();
    if(baseRect.isContain(targetRect)) {
      return;
    }
    entity.addAdjustment(baseRect.getOverflowAdjustment(targetRect));
  }

}
