import 'dart:ui';

enum JoystickInputEventType {
  START,
  UPDATE,
  END
}

/// UIから伝達される移動関連のイベント情報
class JoystickInputEvent {
  JoystickInputEventType type;
  double x;
  double y;
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
}

/// UIからの入力イベントを判定し、
/// ゲーム向けのイベントに変換して通知する
class JoystickEventHandler {

  double _startX = 0;
  double _startY = 0;
  bool _isStarted = false;

  Rect _joystickPosition;

  JoystickEventHandler(Rect position):
    _joystickPosition = position;

  void handle(JoystickInputEvent event) {

    switch(event.type) {
      case JoystickInputEventType.START:
        if(!_isStarted && _isContained(event.x, event.y)) {
          _isStarted = true;
          _startX = event.x;
          _startY = event.y;
        }
        break;
      case JoystickInputEventType.END:
        _isStarted = false;
        break;
      
      case JoystickInputEventType.UPDATE:
        if(_isStarted) {

        }
        break;
    }
  }

  bool _isContained(double x, double y) {
    return _joystickPosition.contains(Offset(x, y));
  }
}


/// Joystickのイベントを受け取るオブジェクトが使用するmixin
mixin JoystickListener {
  onJoystickMove(JoystickMoveEvent event) {
  }
}
