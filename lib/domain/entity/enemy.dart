
import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/engine/services/collision_detect_service.dart';

import 'entity.dart';

class Enemy extends Entity with CollisionEventListener {
  
  Enemy(int id, SpriteResolver spriteResolver, {double x, double y, double z}) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = z;
    this.spriteResolver = spriteResolver;
    this.dimension = Dimension.LEFT;
  }

  List<Sprite> getSprites() {
    if(animation == null) {
      return [];
    }
    Sprite sprite = animation.getSprite();
    if(sprite == null) {
      return [];
    }
    sprite
      ..x = x
      ..y = y + z
      ..dimension = dimension;

    return List<Sprite>.from([sprite]);
  }

  @override
  void onCollide(CollisionEvent event) {
    print(event);
  }
}
