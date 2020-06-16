import 'package:flame/animation.dart';
import 'package:flame/spritesheet.dart';
import '../../engine/image/sprite.dart';
import '../../engine/image/sprite_resolver.dart';
import '../../presentation/flame/flame_sprite.dart';

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

    if(context.state != _currentState) {
      _currentState = context.state;
      //TODO: アニメーションの管理も状態が関係する
      _currentAnimation = _spriteSheets[_currentState].createAnimation(0, stepTime: 0.2);
    }
    if(!_currentAnimation.loaded()) {
      return null;
    }

    return FlameSprite(_currentAnimation.getSprite())
      ..anchor = AnchorPoint.BOTTOM_LEFT
      ..dimension = context.dimension;
  }

  @override
  void update() {
    if(_currentAnimation == null || !_currentAnimation.loaded()) {
      return;
    }
    _currentAnimation?.update(0.016);
  }
}
