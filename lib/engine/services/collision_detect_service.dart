import '../../util/list.dart';
import '../coordinates.dart';
import '../entity/entity.dart';
import '../world.dart';

class CollisionEvent {
  String type;
  Entity source;

  /// 衝突した結果Entityに与えられるべき加速度
  Vector3d force;

  /// 衝突した結果位置調整が必要な場合セットされる
  Vector3d adjustment;

  ///通知される相手にとって、どの方向から衝突したか
  ///(通知される相手が地面と衝突した場合、BOTTOM)
  IntersectDimension intersectDimension;

  CollisionEvent(this.type, this.source, {this.force, this.adjustment});

  String toString() {
    return 'type: $type, source: $source, force: ($force), adjustment: ($adjustment), intersectDimension: $intersectDimension';
  }
}

/// Entity同士の衝突の検出を行うサービス
class CollisionDetectService {
  ZOrderedCollection _entities;

  CollisionDetectService(ZOrderedCollection entities) : _entities = entities;

  void detect(WorldContext context, Entity source, CollisionEvent event) {
    Rect3d sourceRect = source.getRect();
    Rect3d targetRect;
    _entities.forEach((Entity entity) {
      if (entity == null) {
        return;
      }
      targetRect = entity.getRect();
      if (!(entity.isCollidable())) {
        return;
      }
      if (entity == source) {
        return;
      }

      if (sourceRect.isIntersect(entity.getRect())) {
        event.intersectDimension = targetRect.getIntersectDimension(sourceRect);
        entity.onCollide(context, event);
      }
    });
  }
}
