import '../../engine/coordinates.dart';
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

  double getW() => _sprite?.w ?? 0;
  double getH() => _sprite?.h ?? 0;
  double getD() => _sprite?.d ?? 0;

  @override
  void update(double dt, WorldContext context) {
    super.update(dt, context);

    _sprite = spriteResolver.resolve(SpriteContext(state: _type));
  }

  @override
  List<Sprite> getSprites() {
    if (_sprite == null) {
      return [];
    }
    return [
      _sprite
        ..x = x
        ..y = y
        ..z = z
    ];
  }

  Rect3d getRect() {
    double offsetX = _sprite?.getOffsets()?.x ?? 0;
    double offsetY = _sprite?.getOffsets()?.y ?? 0;
    double offsetZ = _sprite?.getOffsets()?.z ?? 0;
    return Rect3d(
        x + offsetX, y + offsetY, z + offsetZ, getW(), getH(), getD());
  }

  @override
  void onCollide(WorldContext context, CollisionEvent event) {}
}
