import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/engine/joystick.dart';

import 'entity.dart';

class JoyStick extends Entity implements JoystickListener {

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
  void update(double dt) {

  }

  @override
  List<Sprite> getSprites() {
    return List<Sprite>.from([
      _baseSprite,
      _knobSprite
    ]);
  }

  @override
  onJoystickMove(JoystickMoveEvent event) {
    switch(event.direction) {
      case JoystickDirection.LEFT:    _knobSprite.x = _baseSprite.x - 30; break;
      case JoystickDirection.RIGHT:   _knobSprite.x = _baseSprite.x + 30; break;
      case JoystickDirection.UP:      _knobSprite.y = _baseSprite.y - 30; break;
      case JoystickDirection.DOWN:    _knobSprite.y = _baseSprite.y + 30; break;
      case JoystickDirection.NEUTRAL:
        _knobSprite.x = _baseSprite.x; 
        _knobSprite.y = _baseSprite.y;
        break;
      default:
    }
  }

  @override
  onJoystickAction(JoystickActionEvent event) {
  }
}
