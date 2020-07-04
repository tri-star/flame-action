import '../../engine/image/sprite.dart';
import '../../engine/image/sprite_resolver.dart';
import '../../engine/world.dart';
import '../../engine/services/collision_detect_service.dart';
import 'entity.dart';

class BasicObstacle extends Entity {
  String _type;
  Sprite _sprite;

  BasicObstacle(int id, String type, SpriteResolver spriteResolver,
      {double x, double y, double z}) {
    assert(type != null && type != '');
    this.id = id;
    this._type = type;
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
