import 'package:flame_action/scene/fight_scene.dart';

import '../../engine/entity/entity.dart';
import '../../engine/global_event.dart';
import '../../engine/image/sprite_resolver.dart';
import '../../engine/input_event.dart';
import '../../engine/world.dart';

class StartButton extends Entity
    with CapturePointerEvent
    implements GameInputListener, PointerEventListener {
  StartButton(int id, String entityName, SpriteResolver spriteResolver,
      {double x, double y}) {
    this.id = id;
    this.entityName = entityName;
    this.x = x;
    this.y = y;
    this.z = 0;
    this.spriteResolver = spriteResolver;
  }

  // @override
  // List<Sprite> getSprites() {
  //   if (animation == null) {
  //     return [];
  //   }
  //   Sprite sprite = animation.getSprite();
  //   if (sprite == null) {
  //     return [];
  //   }
  //   sprite
  //     ..x = x
  //     ..y = y + z;

  //   return List<Sprite>.from([sprite]);
  // }

  void updateState() {}

  /// UIイベントを受け取り、ゲーム用のイベントに変換して各Entityへの通知を行う
  @override
  void onPointerEvent(WorldContext context, UiPointerEvent event) {
    switch (event.type) {
      case PointerEventType.START:
        capturePointer(event);
        setState('pressed');
        GlobalEventBus.instance().notify(
            GlobalEvent('change_scene', payload: {'new_scene': FightScene()}));
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
