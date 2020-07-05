import 'dart:math';
import 'dart:ui';

import 'package:flame_action/engine/image/animation.dart';
import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/engine/input_event.dart';

import '../world.dart';
import 'entity.dart';

class JoyStick extends Entity
    with CapturePointerEvent
    implements GameInputListener, PointerEventListener {
  Sprite _baseSprite;
  Sprite _knobSprite;

  JoyStick(int id, SpriteResolver spriteResolver, {double x, double y}) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = 0;
    this.spriteResolver = spriteResolver;
    this._baseSprite = spriteResolver
        .resolveAnimation(SpriteContext(state: 'base'))
        .getSprite();
    this._knobSprite = spriteResolver
        .resolveAnimation(SpriteContext(state: 'knob'))
        .getSprite();
    _baseSprite.x = x;
    _baseSprite.y = y;
    _knobSprite.x = x;
    _knobSprite.y = y;
  }

  @override
  double getW() {
    return _baseSprite.w;
  }

  @override
  double getH() {
    return _baseSprite.h;
  }

  @override
  void update(double dt, WorldContext context) {}

  @override
  List<Sprite> getSprites() {
    return List<Sprite>.from([_baseSprite, _knobSprite]);
  }

  Animation getAnimation() {
    return spriteResolver.resolveAnimation(SpriteContext(state: 'base'));
  }

  /// UIからの入力イベントをゲーム用のInputMoveEventに変換して、各Entityに通知する
  @override
  void onPointerEvent(WorldContext context, UiPointerEvent event) {
    switch (event.type) {
      case PointerEventType.START:
        capturePointer(event);
        break;
      case PointerEventType.END:
        InputMoveEvent inputEvent = InputMoveEvent(distanceX: 0, distanceY: 0);
        context.inputEventService.notifyMoveEvent(inputEvent);
        break;

      case PointerEventType.UPDATE:
        InputMoveEvent inputEvent = _getMoveEvent(event.x, event.y);
        context.inputEventService.notifyMoveEvent(inputEvent);
        break;
    }
  }

  /// ゲーム用のInputMoveEventを受け取った時の処理
  @override
  onInputMove(InputMoveEvent event) {
    _knobSprite.x = _baseSprite.x + event.distanceX;
    _knobSprite.y = _baseSprite.y + event.distanceY;
  }

  @override
  onInputAction(InputActionEvent event) {}

  ///UI上のポインタの位置をゲーム用の移動距離に変換し、InputMoveEventを生成する
  InputMoveEvent _getMoveEvent(double x, double y) {
    Rect rect = getRenderRect();
    double radAngle = atan2(y - rect.center.dy, x - rect.center.dx);
    double radius = rect.width / 2;
    double distance = min(
        radius, Point(rect.center.dx, rect.center.dy).distanceTo(Point(x, y)));

    double distanceX = distance * cos(radAngle);
    double distanceY = distance * sin(radAngle);
    if (distanceX.abs() <= 15) {
      distanceX = 0;
    }
    if (distanceY.abs() <= 15) {
      distanceY = 0;
    }

    return InputMoveEvent(distanceX: distanceX, distanceY: distanceY);
  }
}
