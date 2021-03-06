import '../engine/coordinates.dart';
import '../engine/entity/entity.dart';
import '../engine/entity/figting_unit.dart';
import '../engine/image/animation.dart';
import '../engine/image/sprite_resolver.dart';
import '../engine/input_event.dart';
import '../engine/services/collision_detect_service.dart';
import '../engine/world.dart';

class Player extends Entity with FightingUnit implements GameInputListener {
  Player(int id, SpriteResolver spriteResolver,
      {String entityName, double x, double y, double z}) {
    this.id = id;
    this.entityName = entityName ?? 'player';
    this.x = x;
    this.y = y;
    this.z = z;
    this.spriteResolver = spriteResolver;
    this.gravityFlag = true;
    this.collidableFlag = true;
    this.hp = 100000;
    this.maxHp = 100000;
    this.tags = ['player'];
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
  @override
  bool changeState(String newState) {
    switch (newState) {
      case 'walk':
        if (state == 'attack') {
          return false;
        }
        if (state == 'damage') {
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
  void onCollide(WorldContext context, CollisionEvent event) {
    super.onCollide(context, event);
    if (event.type == 'attack') {
      setState('damage');
      vx += event.force?.x ?? 0;
      vy += event.force?.y ?? 0;
      y += vy;
      int damageValue = context.randomGenerator.getIntBetween(1000, 1500);
      Entity newEntity = context.entityFactory.create(
          'pop_with_gravity_string', x, y, z + 5,
          options: {'message': damageValue.toString()});
      damage(damageValue.toDouble());
      context.addEntity(newEntity);
    }
    if (event.type == 'collide' &&
        event.source.getTags().contains('obstacle')) {
      if (state == 'damage') {
        vx = 0;
      }
    }
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
