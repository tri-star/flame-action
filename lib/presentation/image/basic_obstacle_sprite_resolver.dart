import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/animation.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/presentation/flame/flame_animation.dart';

class BasicObstacleSpriteResolver extends SpriteResolver {
  static Map<String, Animation> _animations;
  String _name;

  BasicObstacleSpriteResolver(String name) {
    _name = name;
    if (_animations == null) {
      _animations = Map<String, Animation>();
      _animations['ash_tray'] = FlameAnimation(AnimationDefinition(
          'object_01.png', 40, 50, 20, 1, 1, 0.1,
          anchorPoint: AnchorPoint.BOTTOM_CENTER));
      _animations['dust_box01'] = FlameAnimation(AnimationDefinition(
          'object_02.png', 40, 60, 20, 1, 1, 0.1,
          anchorPoint: AnchorPoint.BOTTOM_CENTER));
    }
  }

  @override
  Sprite resolve(SpriteContext context) {
    return null;
  }

  @override
  Animation resolveAnimation(SpriteContext context) {
    return _animations[_name] ?? null;
  }

  @override
  void update() {}
}
