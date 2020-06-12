
import 'package:flame_action/domain/animation/sprite.dart';
import 'package:flame_action/domain/animation/sprite_resolver.dart';

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
    return List<Sprite>.from([
      _spriteResolver.resolve(null)
        ..x = x
        ..y = y
        ..dimension = dimension
    ]);
  }
}
