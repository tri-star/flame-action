import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/engine/joystick.dart';

import '../../engine/world.dart';
import 'entity.dart';

class JoyStick extends Entity implements GameInputListener {
  Sprite _baseSprite;
  Sprite _knobSprite;

  JoyStick(int id, SpriteResolver spriteResolver, {double x, double y}) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = 0;
    this.spriteResolver = spriteResolver;
    this._baseSprite = spriteResolver.resolve(SpriteContext(state: 'base'));
    this._knobSprite = spriteResolver.resolve(SpriteContext(state: 'knob'));
    _baseSprite.x = x;
    _baseSprite.y = y;
    _knobSprite.x = x;
    _knobSprite.y = y;
  }

  @override
  void update(double dt, WorldContext context) {}

  @override
  List<Sprite> getSprites() {
    return List<Sprite>.from([_baseSprite, _knobSprite]);
  }

  @override
  onJoystickMove(JoystickMoveEvent event) {
    _knobSprite.x = _baseSprite.x + event.distanceX;
    _knobSprite.y = _baseSprite.y + event.distanceY;
  }

  @override
  onJoystickAction(InputActionEvent event) {}
}
