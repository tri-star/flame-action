import 'package:flame_action/domain/entity/entity.dart';
import 'package:flame_action/util/list.dart';

import '../coordinates.dart';

class CollisionEvent {
  String type;
  Entity source;

  /// 衝突した結果Entityに与えられるべき加速度
  Vector3d force;

  /// 衝突した結果位置調整が必要な場合セットされる
  Vector3d adjustment;

  CollisionEvent(this.type, this.source, {this.force, this.adjustment});

  String toString() {
    return 'type: $type, source: $source, force: ($force), adjustment: ($adjustment)';
  }
}




/// Entity同士の衝突の検出を行うサービス
class CollisionDetectService {

  ZOrderedCollection _entities;

  CollisionDetectService(ZOrderedCollection entities): 
    _entities = entities;

  void detect(Entity source, CollisionEvent event) {
    Rect3d sourceRect = source.getRect();
    _entities.forEach((Entity entity) {
      if(!(entity.isCollidable())) {
        return;
      }
      if(entity == source) {
        return;
      }

      if(sourceRect.isIntersect(entity.getRect())) {
        entity.onCollide(event);
      }
    });
  }

}
