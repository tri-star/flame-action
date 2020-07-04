import 'world.dart';

enum PointerEventType { START, UPDATE, END }

/// UIから伝達される移動関連のイベント情報
class UiPointerEvent {
  PointerEventType type;
  int pointerId;
  double x;
  double y;

  UiPointerEvent(this.type, this.pointerId, this.x, this.y);
}

/// UIからのイベントを受け付けるオブジェクト用のインターフェース
abstract class PointerEventListener {
  void onPointerEvent(WorldContext context, UiPointerEvent event);
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

enum InputAction { ATTACK }

/// ゲーム向けに伝搬される移動関連のイベント
class InputMoveEvent {
  double distanceX;
  double distanceY;

  InputMoveEvent({this.distanceX, this.distanceY});
}

/// ゲーム向けに伝搬される移動関連のイベント
class InputActionEvent {
  InputAction action;
  InputActionEvent(this.action);
}

/// Joystickのイベントを受け取るオブジェクト用のインターフェース
abstract class GameInputListener {
  onInputMove(InputMoveEvent event);
  onInputAction(InputActionEvent event);
}
