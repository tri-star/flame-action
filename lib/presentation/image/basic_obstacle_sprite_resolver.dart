import 'package:flame/sprite.dart' as Flame;
import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/animation.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/presentation/flame/flame_sprite.dart';

class BasicObstacleSpriteResolver extends SpriteResolver {
  Map<String, Sprite> _sprites;

  BasicObstacleSpriteResolver() {
    _sprites = Map<String, Sprite>();
    _sprites['ash_tray'] = FlameSprite(Flame.Sprite('object_01.png'), d: 20)
      ..anchor = AnchorPoint.BOTTOM_CENTER;
    _sprites['dust_box01'] = FlameSprite(Flame.Sprite('object_02.png'), d: 30)
      ..anchor = AnchorPoint.BOTTOM_CENTER;
  }

  @override
  Sprite resolve(SpriteContext context) {
    return _sprites[context.state];
  }

  @override
  void update() {}

  @override
  Animation resolveAnimation(SpriteContext context) {
    return null;
  }
}
