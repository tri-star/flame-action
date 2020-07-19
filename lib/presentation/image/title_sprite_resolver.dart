import '../../engine/image/animation.dart';
import '../../engine/presentation/flame/flame_animation.dart';
import '../../engine/image/sprite.dart';
import '../../engine/image/sprite_resolver.dart';

class TitleSpriteResolver extends SpriteResolver {
  AnimationDefinition _neutralDefinition;
  Animation _currentAnimation;
  String _currentState;

  TitleSpriteResolver() {
    _neutralDefinition = AnimationDefinition(
        'title.png', 380, 45, 1, 3, 1, 0.08,
        anchorPoint: AnchorPoint.MIDDLE_CENTER);
  }

  @override
  Sprite resolve(SpriteContext context) {
    return null;
  }

  @override
  void update() {}

  @override
  Animation resolveAnimation(SpriteContext context) {
    if (_currentAnimation == null) {
      _currentAnimation = FlameAnimation(_neutralDefinition);
    }
    return _currentAnimation;
  }
}
