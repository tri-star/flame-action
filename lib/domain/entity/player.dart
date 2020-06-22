import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/engine/joystick.dart';

import 'entity.dart';

class Player extends Entity implements JoystickListener {
  
  Player(int id, SpriteResolver spriteResolver, {double x, double y, double z}) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = z;
    this.spriteResolver = spriteResolver;
  }

  @override
  void update(double dt) {
    super.update(dt);
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
      vz = -1;
      state = 'walk';
    }
    if(event.direction == JoystickDirection.DOWN) {
      vz = 1;
      state = 'walk';
    }
    if(event.direction == JoystickDirection.NEUTRAL) {
      vx = 0;
      vz = 0;
      state = 'neutral';
    }
  }

  @override
  onJoystickAction(JoystickActionEvent event) {
    if(event.action == JoystickAction.ATTACK_DOWN) {
      changeState('atack');
    }
  }

  void changeState(String newState) {
    state = 'attack';
  }
}
