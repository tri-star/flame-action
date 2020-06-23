import 'package:flame/animation.dart' as Flame;
import 'package:flame/spritesheet.dart';
import 'package:flame_action/engine/image/sprite.dart';

import '../../engine/image/animation.dart';
import '../../presentation/flame/flame_sprite.dart';

class FlameAnimation extends Animation {

  SpriteSheet _spriteSheet;
  Flame.Animation _animation;

  FlameAnimation(AnimationDefinition definition) {
    this.definition = definition;
    this.currentIndex = 0;

    this._spriteSheet = SpriteSheet(imageName: this.definition.fileName, 
      textureWidth: this.definition.width, 
      textureHeight: this.definition.height, 
      columns: this.definition.cols, 
      rows: this.definition.rows
    );
    _animation = _spriteSheet.createAnimation(this.definition.startRow, stepTime: this.definition.frameSpeed);
    _animation.loop = this.definition.loop ?? true;
  }

  @override
  Sprite getSprite() {
    if(currentIndex != _animation.currentIndex || currentSprite == null) {
      currentSprite = FlameSprite(_animation.getSprite(), d: this.definition.depth);
      currentSprite.anchor = this.definition.anchorPoint;
      currentIndex = _animation.currentIndex;
    }
    return currentSprite;
  }

  @override
  bool isLoaded() {
    return _animation.loaded();
  }

  @override
  bool isDone() {
    return _animation.done();
  }

  @override
  void update() {
    //TODO: 1tick分として正確な値を渡すようにする
    _animation.update(0.016);
  }
}
