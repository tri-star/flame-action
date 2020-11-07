import '../domain/behaviour_tree/behaviour_executor.dart';
import '../domain/behaviour_tree/behaviour_node.dart';
import '../domain/behaviour_tree/behaviour_plan.dart';
import '../domain/behaviour_tree/behaviour_tree_builder.dart';
import '../domain/command/basic_commands.dart';
import '../engine/coordinates.dart';
import '../engine/entity/entity.dart';
import '../engine/entity/figting_unit.dart';
import '../engine/image/animation.dart';
import '../engine/image/sprite_resolver.dart';
import '../engine/services/collision_detect_service.dart';
import '../engine/world.dart';

class Enemy2 extends Entity with FightingUnit {
  BehaviourTreeBuilder _behaviourTreeBuilder;
  BehaviourNode _behaviourTree;
  BehaviourExecutor _behaviourExecutor;
  BehaviourPlan _behaviourPlan;

  Enemy2(int id, String entityName, SpriteResolver spriteResolver,
      BehaviourTreeBuilder behaviourTreeBuilder, double maxHp,
      {double x, double y, double z}) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = z;
    this.entityName = entityName;
    this.spriteResolver = spriteResolver;
    this._behaviourTreeBuilder = behaviourTreeBuilder;
    this._behaviourTree = this._behaviourTreeBuilder?.build();
    if (this._behaviourTree != null) {
      this._behaviourExecutor = BehaviourExecutor(this._behaviourTree);
    }
    this.dimension = Dimension.LEFT;
    this.gravityFlag = true;
    this.collidableFlag = true;
    this.maxHp = maxHp;
    this.hp = maxHp;
    this.tags = ['enemy'];
  }

  void update(WorldContext context) {
    super.update(context);

    if (!context.canControl()) {
      return;
    }

    if (!isDead() && !isDisposed()) {
      if (_behaviourPlan == null || _behaviourPlan.isDone()) {
        _behaviourPlan = _behaviourExecutor?.decidePlan(context, this);
      }
      _behaviourPlan?.execute(context, this);
    }

    if (state != 'dead' && !isDisposed() && isDead()) {
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
        if (state == 'damage') {
          return false;
        }
        if (state == 'dead') {
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
      int damageValue = context.randomGenerator.getIntBetween(1000, 1500);
      DamageCommand(this, damageValue, force: event.force).execute(context);
      Entity newEntity = context.entityFactory.create(
          'pop_with_gravity_string', x, y, z + 5,
          options: {'message': damageValue.toString()});
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
    if (event.type == 'attack') {
      double forceX = (dimension == Dimension.RIGHT) ? 3 : -3;
      CollisionEvent collisionEvent =
          CollisionEvent('attack', this, force: Vector3d(forceX, -10, 0));
      context.collisionDetectService.detect(context, this, collisionEvent);
    }
  }
}
