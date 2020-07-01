import 'dart:math';
import 'dart:ui';

enum PointerEventType { START, UPDATE, END }

/// UIから伝達される移動関連のイベント情報
class UiPointerEvent {
  PointerEventType type;
  int pointerId;
  double x;
  double y;

  UiPointerEvent(this.type, this.pointerId, this.x, this.y);
}

enum JoystickDirection {
  UP_LEFT,
  UP,
  UP_RIGHT,
  LEFT,
  NEUTRAL,
  RIGHT,
  DOWN_LEFT,
  DOWN,
  DOWN_RIGHT,
}

enum JoystickAction {
  ATTACK_DOWN,
  ATTACK_UP,
}

/// ゲーム向けに伝搬される移動関連のイベント
class JoystickMoveEvent {
  double distanceX;
  double distanceY;

  JoystickMoveEvent({this.distanceX, this.distanceY});
}

/// ゲーム向けに伝搬される移動関連のイベント
class JoystickActionEvent {
  JoystickAction action;
  JoystickActionEvent(this.action);
}

/// Joystickのイベントを受け取るオブジェクト用のインターフェース
abstract class JoystickListener {
  onJoystickMove(JoystickMoveEvent event);
  onJoystickAction(JoystickActionEvent event);
}

/// UIからの入力イベントを判定し、
/// ゲーム向けのイベントに変換して通知する
class PointerEventHandler {
  double _startX = 0;
  double _startY = 0;
  int _actionButtonPointerId;
  bool _isStarted;

  Rect _joystickPosition;
  Rect _actionButtonPosition;
  Map<String, JoystickListener> _listeners;

  PointerEventHandler(Rect joyStickPosition, Rect actionButtonPosition)
      : _joystickPosition = joyStickPosition,
        _actionButtonPosition = actionButtonPosition,
        _listeners = Map<String, JoystickListener>(),
        _actionButtonPointerId = 0,
        _isStarted = false;

  addListener(String key, JoystickListener listener) {
    _listeners[key] = listener;
  }

  void handle(UiPointerEvent event) {
    if (_isContainedActionComponent(event.pointerId, event.x, event.y)) {
      handleActionButtonEvent(event);
      return;
    }

    switch (event.type) {
      case PointerEventType.START:
        if (!_isStarted && _isContainedDirectionalComponent(event.x, event.y)) {
          _isStarted = true;
          _startX = event.x;
          _startY = event.y;
        }
        break;
      case PointerEventType.END:
        _isStarted = false;
        JoystickMoveEvent gameEvent =
            JoystickMoveEvent(distanceX: 0, distanceY: 0);
        _notifyMoveEventToListeners(gameEvent);
        break;

      case PointerEventType.UPDATE:
        if (_isStarted) {
          JoystickMoveEvent gameEvent = _getMoveEvent(event.x, event.y);
          _notifyMoveEventToListeners(gameEvent);
        }
        break;
    }
  }

  void handleActionButtonEvent(UiPointerEvent event) {
    _actionButtonPointerId = event.pointerId;
    switch (event.type) {
      case PointerEventType.START:
        JoystickActionEvent gameEvent =
            JoystickActionEvent(JoystickAction.ATTACK_DOWN);
        _notifyActionEventToListeners(gameEvent);
        break;
      case PointerEventType.END:
        JoystickActionEvent gameEvent =
            JoystickActionEvent(JoystickAction.ATTACK_UP);
        _notifyActionEventToListeners(gameEvent);
        break;
      default:
    }
  }

  void _notifyMoveEventToListeners(JoystickMoveEvent event) {
    _listeners.forEach((key, listener) {
      listener.onJoystickMove(event);
    });
  }

  void _notifyActionEventToListeners(JoystickActionEvent event) {
    _listeners.forEach((key, listener) {
      listener.onJoystickAction(event);
    });
  }

  bool _isContainedDirectionalComponent(double x, double y) {
    return _joystickPosition.contains(Offset(x, y));
  }

  bool _isContainedActionComponent(int pointerId, double x, double y) {
    return pointerId == _actionButtonPointerId ||
        _actionButtonPosition.contains(Offset(x, y));
  }

  JoystickMoveEvent _getMoveEvent(double x, double y) {
    double radAngle =
        atan2(y - _joystickPosition.center.dy, x - _joystickPosition.center.dx);
    double radius = _joystickPosition.width / 2;
    double distance = min(
        radius,
        Point(_joystickPosition.center.dx, _joystickPosition.center.dy)
            .distanceTo(Point(x, y)));

    double distanceX = distance * cos(radAngle);
    double distanceY = distance * sin(radAngle);
    if (distanceX.abs() <= 15) {
      distanceX = 0;
    }
    if (distanceY.abs() <= 15) {
      distanceY = 0;
    }

    return JoystickMoveEvent(distanceX: distanceX, distanceY: distanceY);
  }
}
