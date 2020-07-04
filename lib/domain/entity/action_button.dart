import 'dart:ui';

import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/engine/input_event.dart';
import 'package:flame_action/engine/world.dart';

import '../../engine/entity/entity.dart';

class ActionButton extends Entity
    implements GameInputListener, PointerEventListener {
  int _pointerId;
  Rect _buttonPosition;

  ActionButton(int id, SpriteResolver spriteResolver, {double x, double y}) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = 0;
    this.spriteResolver = spriteResolver;
    this._pointerId = 0;
    this._buttonPosition = getRenderRect();
  }

  @override
  List<Sprite> getSprites() {
    if (animation == null) {
      return [];
    }
    Sprite sprite = animation.getSprite();
    if (sprite == null) {
      return [];
    }
    sprite
      ..x = x
      ..y = y + z;

    return List<Sprite>.from([sprite]);
  }

  void updateState() {}

  /// UIイベントを受け取り、ゲーム用のイベントに変換して各Entityへの通知を行う
  @override
  void onPointerEvent(WorldContext context, UiPointerEvent event) {
    if (event.pointerId != _pointerId &&
        !_buttonPosition.contains(Offset(event.x, event.y))) {
      return;
    }

    _pointerId = event.pointerId;
    switch (event.type) {
      case PointerEventType.START:
        InputActionEvent gameEvent = InputActionEvent(InputAction.ATTACK);
        context.inputEventService.notifyActionEvent(gameEvent);
        setState('pressed');
        break;
      case PointerEventType.END:
        setState('neutral');
        break;
      default:
    }
  }

  @override
  onInputMove(InputMoveEvent event) {}

  @override
  onInputAction(InputActionEvent event) {}
}
