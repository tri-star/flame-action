import '../../engine/image/animation.dart';
import '../../engine/presentation/flame/flame_animation.dart';
import '../../engine/image/sprite.dart';
import '../../engine/image/sprite_resolver.dart';

class StartButtonSpriteResolver extends SpriteResolver {
  AnimationDefinition _neutralDefinition;
  AnimationDefinition _pressedDefinition;
  Animation _currentAnimation;
  String _currentState;

  StartButtonSpriteResolver() {
    _neutralDefinition = AnimationDefinition(
        'start_button.png', 200, 50, 1, 1, 1, 0.2,
        anchorPoint: AnchorPoint.MIDDLE_CENTER, key: 'start-button-neutral');
    _pressedDefinition = AnimationDefinition(
        'start_button.png', 200, 50, 1, 3, 1, 0.05,
        anchorPoint: AnchorPoint.MIDDLE_CENTER,
        loop: false,
        key: 'start-button-pressed');
  }

  @override
  Sprite resolve(SpriteContext context) {
    return null;
  }

  @override
  void update() {}

  @override
  Animation resolveAnimation(SpriteContext context) {
    if (_currentAnimation == null || _currentState != context.state) {
      _currentAnimation = context.state == 'neutral'
          ? FlameAnimation(_neutralDefinition)
          : FlameAnimation(_pressedDefinition);
      _currentState = context.state;
    }
    return _currentAnimation;
  }
}
