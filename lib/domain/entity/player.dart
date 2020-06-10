import 'package:flame/animation.dart';
import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';

import 'entity.dart';

class Player extends Entity {
  
  // TODO: 後で適切な場所に移動
  SpriteSheet _spriteSheet;
  Animation _animation;

  Player() {
    _spriteSheet = SpriteSheet(imageName: 'enemy01_state_normal.png', textureWidth: 80, textureHeight: 100, columns: 2, rows: 1);
    _animation = _spriteSheet.createAnimation(0, stepTime: 0.2);
  }

  void update(double dt) {
    _animation.update(dt);
  }

  //TODO: Flameに依存しないようにする
  Sprite get sprite => _animation.getSprite();
}
