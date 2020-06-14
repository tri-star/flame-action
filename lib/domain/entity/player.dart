import 'package:flame_action/engine/animation/sprite.dart';
import 'package:flame_action/engine/animation/sprite_resolver.dart';
import 'package:flame_action/engine/joystick.dart';

import 'entity.dart';

class Player extends Entity implements JoystickListener {
  
  SpriteResolver _spriteResolver;

  Player(SpriteResolver spriteResolver, {double x, double y}) {
    this.x = x;
    this.y = y;
    this._spriteResolver = spriteResolver;
  }

  void update(double dt) {
    x += vx;
    y += vy;
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

  @override
  onJoystickMove(JoystickMoveEvent event) {
    if(event.direction == JoystickDirection.LEFT) {
      vx = -1;
      dimension = Dimension.LEFT;
    }
    if(event.direction == JoystickDirection.RIGHT) {
      vx = 1;
      dimension = Dimension.RIGHT;
    }
    if(event.direction == JoystickDirection.NEUTRAL) {
      vx = 0;
    }
  }
}
