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
      if(changeState('walk')) {
        vx = -2;
        dimension = Dimension.LEFT;
      }
    }
    if(event.direction == JoystickDirection.RIGHT) {
      if(changeState('walk')) {
        vx = 2;
        dimension = Dimension.RIGHT;
      }
    }
    if(event.direction == JoystickDirection.UP) {
      if(changeState('walk')) {
        vz = -1;
        state = 'walk';
      }
    }
    if(event.direction == JoystickDirection.DOWN) {
      if(changeState('walk')) {
        vz = 1;
        state = 'walk';
      }
    }
    if(event.direction == JoystickDirection.NEUTRAL) {
      if(changeState('walk')) {
        vx = 0;
        vz = 0;
        state = 'neutral';
      }
    }
  }

  @override
  onJoystickAction(JoystickActionEvent event) {
    if(event.action == JoystickAction.ATTACK_DOWN) {
      if(changeState('attack')) {
        vx = 0;
        vz = 0;
      }
    }
  }

  /// 状態を変更出来るか確認したうえで状態の変更を行う。
  /// 変更できたかどうかを戻り値で返す。
  bool changeState(String newState) {
    switch(newState) {
      case 'walk':
        if(state == 'attack') {
          return false;
        }
        break;
      case 'attack':
        break;
      case 'newtral':
        break;
    }
    state = newState;
    return true;
  }
}
