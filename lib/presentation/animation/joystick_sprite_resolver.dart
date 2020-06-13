import 'package:flame/sprite.dart' as Flame; 
import 'package:flame_action/domain/animation/sprite.dart';
import 'package:flame_action/domain/animation/sprite_resolver.dart';
import 'package:flame_action/presentation/flame/flame_sprite.dart';

class JoyStickSpriteResolver extends SpriteResolver {

  FlameSprite _baseSprite;
  FlameSprite _knobSprite;

  JoyStickSpriteResolver() {
    _baseSprite = FlameSprite(Flame.Sprite('joystick_base.png'))..anchor = AnchorPoint.MIDDLE_CENTER;
    _knobSprite = FlameSprite(Flame.Sprite('joystick_knob.png'))..anchor = AnchorPoint.MIDDLE_CENTER;
  }

  @override
  Sprite resolve(SpriteContext context) {
    switch(context.state) {
      case 'base': return _baseSprite;
      case 'knob': return _knobSprite;
    }
    throw new UnsupportedError('無効な状態が指定されました: ${context.state}');
  }

  @override
  void update() {
  }

}
