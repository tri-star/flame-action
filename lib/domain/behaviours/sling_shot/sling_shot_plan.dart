import '../../../engine/entity/entity.dart';
import '../../../engine/world.dart';
import '../../../util/timer.dart';

import '../../behaviour_tree/behaviour_plan.dart';
import '../../command/basic_commands.dart';

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
        MakeNeutralCommand(entity).execute();
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
            WalkCommand(entity, x: -2).execute();
          } else {
            WalkCommand(entity, x: 2).execute();
          }
          return;
        }

        if (_isChaseMode) {
          if (isPlayerStatesLeft(entity, player)) {
            WalkCommand(entity, x: -2).execute();
          } else {
            WalkCommand(entity, x: 2).execute();
          }
        } else {
          if (isPlayerStatesLeft(entity, player)) {
            WalkCommand(entity, x: 2).execute();
          } else {
            WalkCommand(entity, x: -2).execute();
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
          _timer = TimeoutTimer(1.0);
        }
        _state = STATE_MOVING;
        break;
      case STATE_MOVING:
        _timer.update();
        Entity player = context.findTaggedFirst('player', useCache: true);

        if (_timer.isDone() || entity.isOverwrappedZ(player.getRect())) {
          _state = STATE_DONE;
          return;
        }

        if (isPlayerStatesAbove(entity, player)) {
          WalkCommand(entity, z: -1).execute();
        } else {
          WalkCommand(entity, z: 1).execute();
        }

        break;
      case STATE_DONE:
        break;
      default:
        throw new UnsupportedError('無効な状態です: $_state');
    }
  }

  bool isPlayerStatesAbove(Entity self, Entity player) =>
      self.getZ() > player.getZ();

  @override
  bool isDone() {
    return _state == STATE_DONE;
  }
}
