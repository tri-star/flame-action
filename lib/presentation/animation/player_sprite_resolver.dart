import 'package:flame/animation.dart';
import 'package:flame/spritesheet.dart';
import 'package:flame_action/engine/animation/sprite.dart';
import 'package:flame_action/engine/animation/sprite_resolver.dart';
import 'package:flame_action/presentation/flame/flame_sprite.dart';

class PlayerSpriteResolver extends SpriteResolver {

  SpriteSheet _spriteSheet;
  Animation _animation;

  PlayerSpriteResolver() {
    _spriteSheet = SpriteSheet(imageName: 'player_normal.png', textureWidth: 60, textureHeight: 100, columns: 1, rows: 1);
    _animation = _spriteSheet.createAnimation(0, stepTime: 0.2);
  }

  @override
  Sprite resolve(SpriteContext context) {
    return FlameSprite(_animation.getSprite())..anchor = AnchorPoint.BOTTOM_LEFT;
  }

  @override
  void update() {
    _animation.update(0.016);
  }
}
