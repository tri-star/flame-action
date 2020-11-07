import '../domain/command/basic_commands.dart';
import '../engine/coordinates.dart';
import '../engine/entity/entity.dart';
import '../engine/image/sprite_resolver.dart';
import '../engine/services/collision_detect_service.dart';
import '../engine/world.dart';
import 'player.dart';

class GenericBullet extends Entity {
  GenericBullet(int id, String entityName, SpriteResolver spriteResolver,
      {double x, double y, double z}) {
    assert(entityName != null && entityName != '');
    this.id = id;
    this.entityName = entityName;
    this.x = x;
    this.y = y;
    this.z = z;
    this.spriteResolver = spriteResolver;
    this.collidableFlag = true;
    this.tags = [];
  }

  @override
  void update(WorldContext context) {
    super.update(context);
    if (x < -100 || x > 2000) {
      dispose();
    }
  }

  @override
  void onCollide(WorldContext context, CollisionEvent event) {
    if (event.source is Player) {
      Vector3d force = Vector3d(
          event.source.getDimension() == Dimension.LEFT ? 2 : -2, -10, 0);
      DamageCommand(event.source, 1234, force: force).execute(context);
      context.addEntity(
          context.entityFactory.create('particle_damage01', x, y, z));

      //TODO: ダメージコマンドに含める
      context.addEntity(context.entityFactory.create(
          'pop_with_gravity_string', x, y, z + 5,
          options: {'message': '1234'}));

      dispose();
    }
  }
}
