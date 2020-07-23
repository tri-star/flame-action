import '../../../engine/coordinates.dart';
import '../../../engine/entity/entity.dart';
import '../../../engine/world.dart';
import '../../../util/timer.dart';
import '../../behaviour_tree/behaviour_plan.dart';
import '../../command/basic_commands.dart';
import 'common_command.dart';

/// 「プレイヤーに近づく」の行動プラン
class CommonBehaviourPlanTargetting extends BehaviourPlan {
  static const int STATE_INITIAL = 0;
  static const int STATE_MOVING = 1;
  static const int STATE_DONE = 2;

  int _state = STATE_INITIAL;
  TimeoutTimer _timer;

  CommonBehaviourPlanTargetting();

  @override
  String get name => 'プレイヤーに近づく';

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

        if (_timer.isDone() || selfRect.isIntersect(playerRect)) {
          _state = STATE_DONE;
          return;
        }

        double forceZ = isPlayerStatesAbove(selfRect, playerRect) ? -1 : 1;
        double forceX = isPlayerStatesLeft(selfRect, playerRect) ? -1 : 1;
        WalkCommand(entity, x: forceX, z: forceZ).execute();
        break;
      case STATE_DONE:
        break;
      default:
        throw new UnsupportedError('無効な状態です: $_state');
    }
  }

  bool isPlayerStatesAbove(Rect3d selfRect, Rect3d playerRect) =>
      selfRect.z > playerRect.z;

  bool isPlayerStatesLeft(Rect3d selfRect, Rect3d playerRect) =>
      selfRect.x > playerRect.x;

  @override
  bool isDone() {
    return _state == STATE_DONE;
  }
}

/// 「攻撃する」の行動プラン
class CommonBehaviourPlanAttack extends BehaviourPlan {
  static const int STATE_INITIAL = 0;
  static const int STATE_WAIT = 2;
  static const int STATE_DONE = 3;

  int _state = STATE_INITIAL;
  TimeoutTimer _timer;

  CommonBehaviourPlanAttack();

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
        MakeNeutralCommand(entity).execute(); //移動中などの場合はキャンセルする
        if (CommonCommandAttack(entity).execute()) {
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
