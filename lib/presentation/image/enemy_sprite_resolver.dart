import 'package:flame/spritesheet.dart';
import 'package:flame_action/engine/image/animation.dart';
import 'package:flame_action/presentation/flame/flame_animation.dart';
import '../../engine/image/sprite.dart';
import '../../engine/image/sprite_resolver.dart';

class EnemySpriteResolver extends SpriteResolver {

  SpriteSheet _spriteSheet;
  Animation _animation;

  EnemySpriteResolver() {
    _spriteSheet = SpriteSheet(imageName: 'enemy01_state_normal.png', textureWidth: 80, textureHeight: 100, columns: 2, rows: 1);
  }

  @override
  Sprite resolve(SpriteContext context) {
    if(_animation == null) {
      _animation = resolveAnimation(context);
    }
    if(!_animation.isLoaded()) {
      return null;
    }
    return _animation.getSprite();
  }

  @override
  Animation resolveAnimation(SpriteContext context) {
    return FlameAnimation(_spriteSheet.createAnimation(0, stepTime: 0.2), anchor: AnchorPoint.BOTTOM_CENTER);
  }

  @override
  void update() {
    if(_animation == null) {
      return;
    }
    _animation.update();
  }
}
