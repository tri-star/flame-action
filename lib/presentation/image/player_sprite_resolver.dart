import 'package:flame/spritesheet.dart';
import '../../engine/image/animation.dart';
import '../../engine/image/sprite.dart';
import '../../engine/image/sprite_resolver.dart';
import '../../presentation/flame/flame_animation.dart';

class PlayerSpriteResolver extends SpriteResolver {

  Map<String, SpriteSheet> _spriteSheets;
  String _currentState;
  Animation _currentAnimation;

  PlayerSpriteResolver() {
    _spriteSheets = Map<String, SpriteSheet>();
    _spriteSheets['neutral'] = SpriteSheet(imageName: 'player_normal.png', textureWidth: 60, textureHeight: 100, columns: 1, rows: 1);
    _spriteSheets['walk'] = SpriteSheet(imageName: 'player_walk.png', textureWidth: 60, textureHeight: 100, columns: 4, rows: 1);
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
      //TODO: アニメーションの管理も状態が関係する
      _currentAnimation = FlameAnimation(_spriteSheets[_currentState].createAnimation(0, stepTime: 0.2), 
        anchor: AnchorPoint.BOTTOM_CENTER,
        dimension: context.dimension
      );
    }
    return _currentAnimation;
  }
}
