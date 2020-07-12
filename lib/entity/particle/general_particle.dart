import '../../engine/image/sprite_resolver.dart';
import '../../engine/entity/entity.dart';
import '../../engine/world.dart';

class GeneralParticle extends Entity {
  GeneralParticle(int id, String entityName, SpriteResolver spriteResolver,
      {double x, double y, double z}) {
    assert(entityName != null && entityName != '');
    this.id = id;
    this.entityName = entityName;
    this.x = x;
    this.y = y;
    this.z = z;
    this.spriteResolver = spriteResolver;
    this.tags = [];
  }

  @override
  void update(WorldContext context) {
    super.update(context);
    if (animation?.isDone() ?? false) {
      dispose();
    }
  }
}
