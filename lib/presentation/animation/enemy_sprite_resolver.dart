import 'package:flame/animation.dart';
import 'package:flame/spritesheet.dart';
import 'package:flame_action/domain/animation/sprite.dart';
import 'package:flame_action/domain/animation/sprite_resolver.dart';
import 'package:flame_action/presentation/flame/flame_sprite.dart';

class EnemySpriteResolver extends SpriteResolver {

  SpriteSheet _spriteSheet;
  Animation _animation;

  EnemySpriteResolver() {
    _spriteSheet = SpriteSheet(imageName: 'enemy01_state_normal.png', textureWidth: 80, textureHeight: 100, columns: 2, rows: 1);
    _animation = _spriteSheet.createAnimation(0, stepTime: 0.2);
  }

  @override
  Sprite resolve(SpriteContext context) {
    return FlameSprite(_animation.getSprite());
  }

  @override
  void update() {
    _animation.update(0.016);
  }
}
