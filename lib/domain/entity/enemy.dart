import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/engine/services/collision_detect_service.dart';

import 'entity.dart';

class Enemy extends Entity {
  Enemy(int id, SpriteResolver spriteResolver, {double x, double y, double z}) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = z;
    this.spriteResolver = spriteResolver;
    this.dimension = Dimension.LEFT;
    this.gravityFlag = true;
    this.collidableFlag = true;
  }

  @override
  void onCollide(CollisionEvent event) {
    super.onCollide(event);
    if (event.type == 'attack') {
      state = 'damage';
      vx += event.force?.x ?? 0;
      vy += event.force?.y ?? 0;
      y += vy;
    }
    if (event.type == 'collide' &&
        event.source.getTags().contains('obstacle')) {
      if (state == 'damage') {
        vx = 0;
      }
    }
  }
}
