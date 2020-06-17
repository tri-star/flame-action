import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/engine/joystick.dart';

import 'entity.dart';

class Player extends Entity implements JoystickListener {
  
  SpriteResolver _spriteResolver;

  Player(SpriteResolver spriteResolver, {double x, double y, double z}) {
    this.x = x;
    this.y = y;
    this.z = z;
    this._spriteResolver = spriteResolver;
  }

  void update(double dt) {
    x += vx;
    y += vy;
    z += vz;
    _spriteResolver.update();
  }

  List<Sprite> getSprites() {
    Sprite sprite = _spriteResolver.resolve(SpriteContext(state: state, dimension: dimension));
    if(sprite == null) {
      return [];
    }
    sprite
      ..x = x
      ..y = y + (z * 0.1)
      ..dimension = dimension;

    return List<Sprite>.from([sprite]);
  }

  @override
  onJoystickMove(JoystickMoveEvent event) {
    if(event.direction == JoystickDirection.LEFT) {
      vx = -2;
      dimension = Dimension.LEFT;
      // TODO: 状態遷移不可能なケースもあるので状態マシンで管理が必要
      state = 'walk';
    }
    if(event.direction == JoystickDirection.RIGHT) {
      vx = 2;
      dimension = Dimension.RIGHT;
      state = 'walk';
    }
    if(event.direction == JoystickDirection.UP) {
      vz = -10;
      state = 'walk';
    }
    if(event.direction == JoystickDirection.DOWN) {
      vz = 10;
      state = 'walk';
    }
    if(event.direction == JoystickDirection.NEUTRAL) {
      vx = 0;
      vz = 0;
      state = 'neutral';
    }
  }
}
