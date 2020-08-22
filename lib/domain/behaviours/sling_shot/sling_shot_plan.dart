import '../../../engine/coordinates.dart';
import '../../../engine/entity/entity.dart';
import '../../../engine/world.dart';
import '../../../util/timer.dart';

import '../../behaviour_tree/behaviour_plan.dart';
import '../../command/basic_commands.dart';

import 'sling_shot_command.dart';

/// 「ニタニタ笑う」の行動プラン
class SlingShotBehaviourPlanGlimming extends BehaviourPlan {
  static const int STATE_INITIAL = 0;
  static const int STATE_GRIMMING = 1;
  static const int STATE_DONE = 2;

  int _state = STATE_INITIAL;
  TimeoutTimer _timer;

  SlingShotBehaviourPlanGlimming();

  @override
  String get name => 'ニタニタ笑う';

  @override
  void init() {
    _state = STATE_INITIAL;
    _timer = null;
  }

  @override
  void execute(WorldContext context, Entity entity) {
    switch (_state) {
      case STATE_INITIAL:
        _timer = TimeoutTimer(0.6);
        _state = STATE_GRIMMING;
        MakeNeutralCommand(entity).execute(context);
        break;
      case STATE_GRIMMING:
        _timer.update();
        if (_timer.isDone()) {
          _state = STATE_DONE;
        }
        break;
      case STATE_DONE:
        break;
      default:
        throw new UnsupportedError('無効な状態です: $_state');
    }
  }

  @override
  bool isDone() {
    return _state == STATE_DONE;
  }
}

/// 「距離を取る」、「追いかける」の行動プラン
class SlingShotBehaviourPlanKeepDistance extends BehaviourPlan {
  static const int STATE_INITIAL = 0;
  static const int STATE_MOVING = 1;
  static const int STATE_DONE = 2;

  int _state = STATE_INITIAL;
  TimeoutTimer _timer;
  double _distance;
  bool _isChaseMode;

  SlingShotBehaviourPlanKeepDistance(double distance) : _distance = distance;

  @override
  String get name => '距離を取る';

  @override
  void init() {
    _state = STATE_INITIAL;
    _timer = null;
    _isChaseMode = null;
  }

  @override
  void execute(WorldContext context, Entity entity) {
    Entity player = context.findTaggedFirst('player', useCache: true);
    double playerDistance = (player.getX() - entity.getX()).abs();
    bool isFarEnough = playerDistance > _distance;
    switch (_state) {
      case STATE_INITIAL:
        if (_timer == null) {
          _timer = TimeoutTimer(1.0);
        }
        _state = STATE_MOVING;
        _isChaseMode = isFarEnough;
        break;
      case STATE_MOVING:
        _timer.update();

        if (_timer.isDone()) {
          _state = STATE_DONE;
          if (isPlayerStatesLeft(entity, player)) {
            WalkCommand(entity, x: -2).execute(context);
          } else {
            WalkCommand(entity, x: 2).execute(context);
          }
          return;
        }

        if (_isChaseMode) {
          if (isPlayerStatesLeft(entity, player)) {
            WalkCommand(entity, x: -2).execute(context);
          } else {
            WalkCommand(entity, x: 2).execute(context);
          }
        } else {
          if (isPlayerStatesLeft(entity, player)) {
            WalkCommand(entity, x: 2).execute(context);
          } else {
            WalkCommand(entity, x: -2).execute(context);
          }
        }

        break;
      case STATE_DONE:
        break;
      default:
        throw new UnsupportedError('無効な状態です: $_state');
    }
  }

  bool isPlayerStatesLeft(Entity self, Entity player) =>
      self.getX() > player.getX();

  @override
  bool isDone() {
    return _state == STATE_DONE;
  }
}

/// 「プレイヤーを狙う」の行動プラン
class SlingShotBehaviourPlanTargetting extends BehaviourPlan {
  static const int STATE_INITIAL = 0;
  static const int STATE_MOVING = 1;
  static const int STATE_DONE = 2;

  int _state = STATE_INITIAL;
  TimeoutTimer _timer;

  SlingShotBehaviourPlanTargetting();

  @override
  String get name => 'プレイヤーを狙う';

  @override
  void init() {
    _state = STATE_INITIAL;
    _timer = null;
  }

  @override
  void execute(WorldContext context, Entity entity) {
    switch (_state) {
      case STATE_INITIAL:
        if (_timer == null) {
          _timer = TimeoutTimer(1.5);
        }
        _state = STATE_MOVING;
        break;
      case STATE_MOVING:
        _timer.update();
        Entity player = context.findTaggedFirst('player', useCache: true);
        Rect3d selfRect = entity.getRect();
        Rect3d playerRect = player.getRect();
        playerRect.setDepth(1);

        if (_timer.isDone() || entity.isOverwrappedZ(playerRect)) {
          _state = STATE_DONE;
          return;
        }

        if (isPlayerStatesAbove(selfRect, playerRect)) {
          WalkCommand(entity, z: -1).execute(context);
        } else {
          WalkCommand(entity, z: 1).execute(context);
        }

        break;
      case STATE_DONE:
        break;
      default:
        throw new UnsupportedError('無効な状態です: $_state');
    }
  }

  bool isPlayerStatesAbove(Rect3d selfRect, Rect3d playerRect) =>
      selfRect.z > playerRect.z;

  @override
  bool isDone() {
    return _state == STATE_DONE;
  }
}

/// 「攻撃する」の行動プラン
class SlingShotBehaviourPlanAttack extends BehaviourPlan {
  static const int STATE_INITIAL = 0;
  static const int STATE_WAIT = 2;
  static const int STATE_DONE = 3;

  int _state = STATE_INITIAL;
  TimeoutTimer _timer;

  SlingShotBehaviourPlanAttack();

  @override
  String get name => '攻撃する';

  @override
  void init() {
    _state = STATE_INITIAL;
    _timer = null;
  }

  @override
  void execute(WorldContext context, Entity entity) {
    switch (_state) {
      case STATE_INITIAL:
        MakeNeutralCommand(entity).execute(context); //移動中などの場合はキャンセルする
        if (SlingShotCommandAttack(entity).execute(context)) {
          _state = STATE_WAIT;
        }
        break;

      case STATE_WAIT:
        if (entity.getState() != 'attack') {
          _state = STATE_DONE;
        }
        break;
      case STATE_DONE:
        break;
      default:
        throw new UnsupportedError('無効な状態です: $_state');
    }
  }

  @override
  bool isDone() {
    return _state == STATE_DONE;
  }
}
