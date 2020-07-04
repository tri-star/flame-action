import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/engine/joystick.dart';

import 'entity.dart';

class ActionButton extends Entity implements GameInputListener {
  ActionButton(int id, SpriteResolver spriteResolver, {double x, double y}) {
    this.id = id;
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

  @override
  onInputMove(JoystickMoveEvent event) {}

  @override
  onInputAction(InputActionEvent event) {
    state = event.state == 'down' ? 'pressed' : 'neutral';
  }
}
