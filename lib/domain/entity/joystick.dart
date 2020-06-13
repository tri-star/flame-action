import 'package:flame_action/domain/animation/sprite.dart';
import 'package:flame_action/domain/animation/sprite_resolver.dart';

import 'entity.dart';

class JoyStick extends Entity {

  SpriteResolver _spriteResolver;
  Sprite _baseSprite;
  Sprite _knobSprite;

  JoyStick(SpriteResolver spriteResolver, {double x, double y}) {
    this.x = x;
    this.y = y;
    this._spriteResolver = spriteResolver;
    this._baseSprite = _spriteResolver.resolve(SpriteContext(state: 'base'));
    this._knobSprite = _spriteResolver.resolve(SpriteContext(state: 'knob'));
  }

  void update(double dt) {
    _baseSprite.x = x;
    _baseSprite.y = y;
    _knobSprite.x = x;
    _knobSprite.y = y;
  }

  List<Sprite> getSprites() {
    return List<Sprite>.from([
      _baseSprite,
      _knobSprite
    ]);
  }

}
