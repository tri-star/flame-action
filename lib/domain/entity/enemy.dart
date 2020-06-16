
import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';

import 'entity.dart';

class Enemy extends Entity {
  
  SpriteResolver _spriteResolver;

  Enemy(SpriteResolver spriteResolver, {double x, double y}) {
    this.x = x;
    this.y = y;
    this._spriteResolver = spriteResolver;
    this.dimension = Dimension.LEFT;
  }

  void update(double dt) {
    _spriteResolver.update();
  }

  List<Sprite> getSprites() {
    Sprite sprite = _spriteResolver.resolve(null);
    if(sprite == null) {
      return [];
    }
    sprite
      ..x = x
      ..y = y
      ..dimension = dimension;

    return List<Sprite>.from([sprite]);
  }
}
