import 'package:flame_action/engine/image/animation.dart';
import '../../engine/presentation/flame/flame_animation.dart';
import '../../engine/image/sprite.dart';
import '../../engine/image/sprite_resolver.dart';

class ActionButtonSpriteResolver extends SpriteResolver {
  AnimationDefinition _neutralDefinition;
  AnimationDefinition _pressedDefinition;
  Animation _currentAnimation;
  String _currentState;

  ActionButtonSpriteResolver() {
    _neutralDefinition = AnimationDefinition(
        'action-button.png', 60, 60, 1, 1, 1, 0.2,
        anchorPoint: AnchorPoint.MIDDLE_CENTER, key: 'action-button-neutral');
    _pressedDefinition = AnimationDefinition(
        'action-button.png', 60, 60, 1, 3, 1, 0.05,
        anchorPoint: AnchorPoint.MIDDLE_CENTER,
        loop: false,
        key: 'action-button-pressed');
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
