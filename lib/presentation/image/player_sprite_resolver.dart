import 'package:flame/spritesheet.dart';
import '../../engine/image/animation.dart';
import '../../engine/image/sprite.dart';
import '../../engine/image/sprite_resolver.dart';
import '../../presentation/flame/flame_animation.dart';

class PlayerSpriteResolver extends SpriteResolver {

  Map<String, AnimationDefinition> _definitions;
  String _currentState;
  Animation _currentAnimation;

  PlayerSpriteResolver() {
    _definitions = Map<String, AnimationDefinition>();
    _definitions['neutral'] = AnimationDefinition('player_normal.png', 60, 100, 10, 1, 1, 0.1, anchorPoint: AnchorPoint.BOTTOM_CENTER);
    _definitions['walk'] = AnimationDefinition('player_walk.png', 60, 100, 10, 4, 1, 0.2, anchorPoint: AnchorPoint.BOTTOM_CENTER);
    _definitions['attack'] = AnimationDefinition('player_attack01.png', 80, 100, 10, 5, 1, 0.08, 
      anchorPoint: AnchorPoint.BOTTOM_CENTER, 
      loop: false, 
      afterWait: 0.3,
      events: {
        4: AnimationFrameEvent('attack')
      });
    _currentState = '';
  }

  @override
  Sprite resolve(SpriteContext context) {
    if(_currentAnimation == null || context.state != _currentState) {
      _currentAnimation = resolveAnimation(context);
    }
    if(!_currentAnimation.isLoaded()) {
      return null;
    }
    return _currentAnimation.getSprite();
  }

  @override
  void update() {
    if(_currentAnimation == null || !_currentAnimation.isLoaded()) {
      return;
    }
    _currentAnimation?.update();
  }

  @override
  Animation resolveAnimation(SpriteContext context) {
    if(context.state != _currentState) {
      _currentState = context.state;

      _currentAnimation = FlameAnimation(_definitions[_currentState]);
    }
    return _currentAnimation;
  }
}
