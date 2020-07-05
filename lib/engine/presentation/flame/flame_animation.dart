import 'package:flame/animation.dart' as Flame;
import 'package:flame/spritesheet.dart';
import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/util/timer.dart';

import '../../image/animation.dart';
import 'flame_sprite.dart';

class FlameAnimation extends Animation {
  static Map<String, SpriteSheet> _spriteSheetCache;

  SpriteSheet _spriteSheet;
  Flame.Animation _animation;
  TimeoutTimer _afterWaitTimer;

  FlameAnimation(AnimationDefinition definition) {
    this.definition = definition;
    this.currentIndex = 0;

    this._spriteSheet = _loadSpriteSheet(definition);
    _animation = _spriteSheet.createAnimation(this.definition.startRow,
        stepTime: this.definition.frameSpeed);
    _animation.loop = this.definition.loop ?? true;
    _afterWaitTimer = TimeoutTimer(this.definition.afterWait);
  }

  @override
  Sprite getSprite() {
    if (currentSprite == null) {
      update();
    }
    return currentSprite;
  }

  @override
  bool isLoaded() {
    return _animation.loaded();
  }

  @override
  bool isDone() {
    if (!_animation.done()) {
      return false;
    }
    _afterWaitTimer.update();
    return _afterWaitTimer.isDone();
  }

  @override
  void update({AnimationEventCallback animationEventCallback}) {
    //TODO: 1tick分として正確な値を渡すようにする
    _animation.update(0.016);

    if (currentIndex != _animation.currentIndex || currentSprite == null) {
      currentSprite = FlameSprite(_animation.getSprite(),
          w: definition.width.toDouble(),
          h: definition.height.toDouble(),
          d: definition.depth);
      currentSprite.anchor = definition.anchorPoint;
      currentIndex = _animation.currentIndex;

      if (animationEventCallback != null &&
          (definition.events?.containsKey(currentIndex) ?? false)) {
        animationEventCallback(definition.events[currentIndex]);
      }
    }
  }

  SpriteSheet _loadSpriteSheet(AnimationDefinition definition) {
    if (_spriteSheetCache == null) {
      _spriteSheetCache = Map<String, SpriteSheet>();
    }
    if (_spriteSheetCache.containsKey(definition.key)) {
      return _spriteSheetCache[definition.key];
    }

    _spriteSheetCache[definition.key] = SpriteSheet(
        imageName: this.definition.fileName,
        textureWidth: this.definition.width,
        textureHeight: this.definition.height,
        columns: this.definition.cols,
        rows: this.definition.rows);

    return _spriteSheetCache[definition.key];
  }
}
