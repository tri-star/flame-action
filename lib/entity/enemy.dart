import 'package:flame_action/engine/entity/figting_unit.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/engine/services/collision_detect_service.dart';
import 'package:flame_action/engine/world.dart';

import '../engine/entity/entity.dart';

class Enemy extends Entity with FightingUnit {
  Enemy(int id, String entityName, SpriteResolver spriteResolver, double maxHp,
      {double x, double y, double z}) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = z;
    this.entityName = entityName;
    this.spriteResolver = spriteResolver;
    this.dimension = Dimension.LEFT;
    this.gravityFlag = true;
    this.collidableFlag = true;
    this.maxHp = maxHp;
    this.hp = maxHp;
  }

  void update(WorldContext context) {
    super.update(context);

    if (state != 'dead' && isDead()) {
      disableGravity();
      collidableFlag = false;
      setState('dead');
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
  String getNextState(String currentState) {
    switch (currentState) {
      case 'dead':
        return 'disposed';
    }
    return 'neutral';
  }

  @override
  void onCollide(WorldContext context, CollisionEvent event) {
    super.onCollide(context, event);
    if (event.type == 'attack') {
      setState('damage');
      vx += event.force?.x ?? 0;
      vy += event.force?.y ?? 0;
      y += vy;
      Entity newEntity = context.entityFactory.create(
          'pop_with_gravity_string', x, y, z + 5,
          options: {'message': '1234'});
      damage(1234);
      context.addEntity(newEntity);
    }
    if (event.type == 'collide' &&
        event.source.getTags().contains('obstacle')) {
      if (state == 'damage') {
        vx = 0;
      }
    }
  }
}
