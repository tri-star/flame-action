import 'package:flame/spritesheet.dart';
import 'package:flame_action/engine/image/animation.dart';
import 'package:flame_action/presentation/flame/flame_animation.dart';
import '../../engine/image/sprite.dart';
import '../../engine/image/sprite_resolver.dart';

class ActionButtonSpriteResolver extends SpriteResolver {

  SpriteSheet _spriteSheetButton;
  SpriteSheet _spriteSheetPressed;
  Animation _currentAnimation;
  String _currentState;

  ActionButtonSpriteResolver() {
    _spriteSheetButton = SpriteSheet(imageName: 'action-button.png', textureWidth: 60, textureHeight: 60, columns: 1, rows: 1);
    _spriteSheetPressed = SpriteSheet(imageName: 'action-button.png', textureWidth: 60, textureHeight: 60, columns: 3, rows: 1);
  }

  @override
  Sprite resolve(SpriteContext context) {
    return null;
  }

  @override
  void update() {
  }

  @override
  Animation resolveAnimation(SpriteContext context) {
    if(_currentAnimation == null || _currentState != context.state) {
      _currentAnimation = context.state == 'neutral' ? FlameAnimation(_spriteSheetButton.createAnimation(0, stepTime: 0.2), anchor: AnchorPoint.MIDDLE_CENTER) : 
        FlameAnimation(_spriteSheetPressed.createAnimation(0, stepTime: 0.05), anchor: AnchorPoint.MIDDLE_CENTER, loop: false);
      _currentState = context.state;
    }
    return _currentAnimation;
  }

}
