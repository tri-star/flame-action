import 'dart:ui';

enum PointerEventType {
  START,
  UPDATE,
  END
}

/// UIから伝達される移動関連のイベント情報
class UiPointerEvent {
  PointerEventType type;
  double x;
  double y;

  UiPointerEvent(this.type, this.x, this.y);
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

/// ゲーム向けに伝搬される移動関連のイベント
class JoystickMoveEvent {
  JoystickDirection direction;
  double distance;

  JoystickMoveEvent({this.direction, this.distance});
}

/// Joystickのイベントを受け取るオブジェクト用のインターフェース
abstract class JoystickListener {
  onJoystickMove(JoystickMoveEvent event);
}


/// UIからの入力イベントを判定し、
/// ゲーム向けのイベントに変換して通知する
class PointerEventHandler {

  double _startX = 0;
  double _startY = 0;
  bool _isStarted = false;

  Rect _joystickPosition;
  Map<String, JoystickListener> _listeners;

  PointerEventHandler(Rect position):
    _joystickPosition = position,
    _listeners = Map<String, JoystickListener>();

  addListener(String key, JoystickListener listener) {
    _listeners[key] = listener;
  }

  void handle(UiPointerEvent event) {

    switch(event.type) {
      case PointerEventType.START:
        if(!_isStarted && _isContained(event.x, event.y)) {
          _isStarted = true;
          _startX = event.x;
          _startY = event.y;
        }
        break;
      case PointerEventType.END:
        _isStarted = false;
        JoystickMoveEvent gameEvent = JoystickMoveEvent(direction: JoystickDirection.NEUTRAL);
        _notifyListeners(gameEvent);
        break;
      
      case PointerEventType.UPDATE:
        if(_isStarted) {
          JoystickMoveEvent gameEvent = JoystickMoveEvent(direction: _getDimension(event.x, event.y));
          _notifyListeners(gameEvent);
        }
        break;
    }
  }

  void _notifyListeners(JoystickMoveEvent event) {
    _listeners.forEach((key, listener) {
      listener.onJoystickMove(event);
    });
  }

  bool _isContained(double x, double y) {
    return _joystickPosition.contains(Offset(x, y));
  }

  JoystickDirection _getDimension(double x, double y) {
    if(_joystickPosition.center.dx - x > 15) {
      return JoystickDirection.LEFT;
    } else if (_joystickPosition.center.dx - x < -15) {
      return JoystickDirection.RIGHT;
    } else if (_joystickPosition.center.dy - y > 15) {
      return JoystickDirection.UP;
    } else if (_joystickPosition.center.dy - y < -15) {
      return JoystickDirection.DOWN;
    }
    return JoystickDirection.NEUTRAL;
  }
}
