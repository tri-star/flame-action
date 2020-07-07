import '../../engine/image/sprite.dart';
import '../../engine/image/sprite_resolver.dart';
import '../../engine/world.dart';
import '../../engine/services/collision_detect_service.dart';
import '../../engine/entity/entity.dart';

class BasicObstacle extends Entity {
  Sprite _sprite;

  BasicObstacle(int id, String entityName, SpriteResolver spriteResolver,
      {double x, double y, double z}) {
    assert(entityName != null && entityName != '');
    this.id = id;
    this.entityName = entityName;
    this.x = x;
    this.y = y;
    this.z = z;
    this.spriteResolver = spriteResolver;
    this.collidableFlag = true;
    this.tags = ["obstacle"];
  }

  @override
  void onCollide(WorldContext context, CollisionEvent event) {}
}
