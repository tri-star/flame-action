import 'package:flame_action/engine/image/animation.dart';
import 'package:flame_action/presentation/flame/flame_animation.dart';
import '../../engine/image/sprite.dart';
import '../../engine/image/sprite_resolver.dart';

class EnemySpriteResolver extends SpriteResolver {
  Map<String, AnimationDefinition> _definitions;
  String _currentState;
  Animation _currentAnimation;

  EnemySpriteResolver() {
    _definitions = Map<String, AnimationDefinition>();
    _definitions['neutral'] = AnimationDefinition(
        'enemy01_state_normal.png', 80, 100, 20, 2, 1, 0.2,
        anchorPoint: AnchorPoint.BOTTOM_CENTER);
    _definitions['damage'] = AnimationDefinition(
        'enemy01_state_damage.png', 80, 100, 20, 1, 1, 0.08,
        anchorPoint: AnchorPoint.BOTTOM_CENTER, loop: false, afterWait: 1);
  }

  @override
  Sprite resolve(SpriteContext context) {
    if (_currentAnimation == null || context.state != _currentState) {
      _currentAnimation = resolveAnimation(context);
    }
    if (!_currentAnimation.isLoaded()) {
      return null;
    }
    return _currentAnimation.getSprite();
  }

  @override
  void update() {
    if (_currentAnimation == null || !_currentAnimation.isLoaded()) {
      return;
    }
    _currentAnimation?.update();
  }

  @override
  Animation resolveAnimation(SpriteContext context) {
    if (context.state != _currentState) {
      _currentState = context.state;

      _currentAnimation = FlameAnimation(_definitions[_currentState]);
    }
    return _currentAnimation;
  }
}
