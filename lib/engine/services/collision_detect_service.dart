import 'package:flame_action/domain/entity/entity.dart';
import 'package:flame_action/util/list.dart';

import '../coordinates.dart';

class CollisionEvent {
  String type;
  Entity source;
  Vector3d force;

  CollisionEvent(this.type, this.source, this.force);

  String toString() {
    return 'type: $type, source: $source, force: ($force)';
  }
}


/// 衝突判定を行うEntityが持つmixin
mixin CollisionEventListener {
  void onCollide(CollisionEvent event);
}


/// Entity同士の衝突の検出を行うサービス
class CollisionDetectService {

  ZOrderedCollection _entities;

  CollisionDetectService(ZOrderedCollection entities): 
    _entities = entities;

  void detect(Entity source, CollisionEvent event) {
    Rect3d sourceRect = source.getRect();
    _entities.forEach((Entity entity) {
      if(!(entity is CollisionEventListener)) {
        return;
      }
      if(entity == source) {
        return;
      }

      if(sourceRect.isIntersect(entity.getRect())) {
        (entity as CollisionEventListener).onCollide(event);
      }
    });
  }

}
