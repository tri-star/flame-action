import 'package:flame_action/engine/image/animation.dart';
import 'package:flame_action/presentation/flame/flame_animation.dart';
import '../../engine/image/sprite.dart';
import '../../engine/image/sprite_resolver.dart';

class EnemySpriteResolver extends SpriteResolver {

  AnimationDefinition _definition;
  Animation _animation;

  EnemySpriteResolver() {
    _definition = AnimationDefinition('enemy01_state_normal.png', 80, 100, 10, 2, 1, 0.2, anchorPoint: AnchorPoint.BOTTOM_CENTER);
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
    if(_animation == null) {
      _animation = FlameAnimation(_definition);
    }
    return _animation;
  }

  @override
  void update() {
    if(_animation == null) {
      return;
    }
    _animation.update();
  }
}
