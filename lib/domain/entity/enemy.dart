import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/engine/services/collision_detect_service.dart';
import 'package:flame_action/engine/world.dart';

import '../../engine/entity/entity.dart';

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
  void onCollide(WorldContext context, CollisionEvent event) {
    super.onCollide(context, event);
    if (event.type == 'attack') {
      setState('damage');
      vx += event.force?.x ?? 0;
      vy += event.force?.y ?? 0;
      y += vy;
      Entity newEntity = context.entityFactory.create(
          'pop_with_gravity_string', x, y, z + 5,
          options: {'message': '1234'});
      context.addEntity(newEntity);
    }
    if (event.type == 'collide' &&
        event.source.getTags().contains('obstacle')) {
      if (state == 'damage') {
        vx = 0;
      }
    }
  }
}
