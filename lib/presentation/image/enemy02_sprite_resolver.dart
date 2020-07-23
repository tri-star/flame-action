import 'package:flame_action/engine/image/animation.dart';
import '../../engine/image/sprite.dart';
import '../../engine/image/sprite_resolver.dart';
import '../../engine/presentation/flame/flame_animation.dart';

class Enemy02SpriteResolver extends SpriteResolver {
  Map<String, AnimationDefinition> _definitions;
  String _currentState;
  Animation _currentAnimation;

  Enemy02SpriteResolver() {
    _definitions = Map<String, AnimationDefinition>();
    _definitions['neutral'] = AnimationDefinition(
        'enemy02_walk.png', 50, 100, 20, 1, 1, 0.2,
        key: 'enemy02_neutral', anchorPoint: AnchorPoint.BOTTOM_CENTER);
    _definitions['walk'] = AnimationDefinition(
        'enemy02_walk.png', 50, 100, 20, 4, 1, 0.1,
        anchorPoint: AnchorPoint.BOTTOM_CENTER, loop: true);
    _definitions['damage'] = AnimationDefinition(
        'enemy02_damage.png', 50, 100, 20, 1, 1, 0.08,
        anchorPoint: AnchorPoint.BOTTOM_CENTER, loop: false, afterWait: 1);
    _definitions['dead'] = AnimationDefinition(
        'enemy02_damage.png', 80, 100, 20, 1, 1, 0.08,
        anchorPoint: AnchorPoint.BOTTOM_CENTER, loop: false, afterWait: 2);
    _definitions['attack'] = AnimationDefinition(
        'enemy02_attack.png', 70, 100, 20, 2, 1, 0.2,
        anchorPoint: AnchorPoint.BOTTOM_CENTER,
        loop: false,
        afterWait: 1.0,
        events: {1: AnimationFrameEvent('attack')});
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
