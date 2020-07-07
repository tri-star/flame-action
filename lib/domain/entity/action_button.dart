import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/engine/input_event.dart';
import 'package:flame_action/engine/world.dart';

import '../../engine/entity/entity.dart';

class ActionButton extends Entity
    with CapturePointerEvent
    implements GameInputListener, PointerEventListener {
  ActionButton(int id, String entityName, SpriteResolver spriteResolver,
      {double x, double y}) {
    this.id = id;
    this.entityName = entityName;
    this.x = x;
    this.y = y;
    this.z = 0;
    this.spriteResolver = spriteResolver;
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
    switch (event.type) {
      case PointerEventType.START:
        capturePointer(event);
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
