import 'package:flame/animation.dart' as Flame;
import 'package:flame_action/domain/entity/entity.dart';
import 'package:flame_action/engine/image/sprite.dart';

import '../../engine/image/animation.dart';
import '../../presentation/flame/flame_sprite.dart';

class FlameAnimation extends Animation {

  Flame.Animation _animation;
  int _currentIndex;
  Sprite _currentSprite;
  AnchorPoint _anchorPoint;
  Dimension _dimension;


  FlameAnimation(Flame.Animation flameAnimation, {AnchorPoint anchor, Dimension dimension}):
    _animation = flameAnimation,
    _currentIndex = 0,
    _anchorPoint = anchor ?? AnchorPoint.TOP_LEFT,
    _dimension = dimension;

  @override
  Sprite getSprite() {
    if(_currentIndex != _animation.currentIndex || _currentSprite == null) {
      _currentSprite = FlameSprite(_animation.getSprite());
      _currentSprite.anchor = _anchorPoint;
      _currentSprite.dimension = _dimension;
      _currentIndex = _animation.currentIndex;
    }
    return _currentSprite;
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
  bool isLoop() {
    return _animation.loop;
  }

  @override
  void update() {
    //TODO: 1tick分として正確な値を渡すようにする
    _animation.update(0.016);
  }

}
