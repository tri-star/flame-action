import 'package:flame_action/engine/animation/sprite.dart';
import 'package:flame_action/engine/animation/sprite_resolver.dart';

import 'entity.dart';

class Player extends Entity {
  
  SpriteResolver _spriteResolver;

  Player(SpriteResolver spriteResolver, {double x, double y}) {
    this.x = x;
    this.y = y;
    this._spriteResolver = spriteResolver;
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
