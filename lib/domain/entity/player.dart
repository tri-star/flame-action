import 'package:flame_action/engine/coordinates.dart';
import 'package:flame_action/engine/image/animation.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/engine/joystick.dart';
import 'package:flame_action/engine/services/collision_detect_service.dart';

import '../../engine/world.dart';
import 'entity.dart';

class Player extends Entity implements GameInputListener {
  Player(int id, SpriteResolver spriteResolver,
      {double x, double y, double z}) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = z;
    this.spriteResolver = spriteResolver;
    this.gravityFlag = true;
    this.collidableFlag = true;
  }

  @override
  onInputMove(InputMoveEvent event) {
    if (event.distanceX < -1) {
      if (changeState('walk')) {
        vx = -2;
        dimension = Dimension.LEFT;
      }
    } else if (event.distanceX > 1) {
      if (changeState('walk')) {
        vx = 2;
        dimension = Dimension.RIGHT;
      }
    } else {
      vx = 0;
    }
    if (event.distanceY < -1) {
      if (changeState('walk')) {
        vz = -1;
      }
    } else if (event.distanceY > 1) {
      if (changeState('walk')) {
        vz = 1;
      }
    } else {
      vz = 0;
    }
    if (event.distanceX == 0 && event.distanceY == 0) {
      if (changeState('neutral')) {
        vx = 0;
        vz = 0;
      }
    }
  }

  @override
  onInputAction(InputActionEvent event) {
    if (event.action == InputAction.ATTACK) {
      if (changeState('attack')) {
        vx = 0;
        vz = 0;
      }
    }
  }

  /// 状態を変更出来るか確認したうえで状態の変更を行う。
  /// 変更できたかどうかを戻り値で返す。
  bool changeState(String newState) {
    switch (newState) {
      case 'walk':
        if (state == 'attack') {
          return false;
        }
        break;
      case 'attack':
        break;
      case 'neutral':
        if (state == 'attack') {
          return false;
        }
        break;
    }
    setState(newState);
    return true;
  }

  @override
  void onAnimationEvent(WorldContext context, AnimationFrameEvent event) {
    double forceX = (dimension == Dimension.RIGHT) ? 3 : -3;
    CollisionEvent collisionEvent =
        CollisionEvent('attack', this, force: Vector3d(forceX, -18, 0));
    context.collisionDetectService.detect(context, this, collisionEvent);
    vy = -10;
    y += vy;
  }
}
