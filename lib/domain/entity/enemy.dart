
import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';

import 'entity.dart';

class Enemy extends Entity {
  
  Enemy(int id, SpriteResolver spriteResolver, {double x, double y, double z}) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = z;
    this.spriteResolver = spriteResolver;
    this.dimension = Dimension.LEFT;
  }

  List<Sprite> getSprites() {
    Sprite sprite = spriteResolver.resolve(null);
    if(sprite == null) {
      return [];
    }
    sprite
      ..x = x
      ..y = y + (z * 0.1)
      ..dimension = dimension;

    return List<Sprite>.from([sprite]);
  }
}
