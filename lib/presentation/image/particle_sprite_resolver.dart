import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/animation.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import '../../engine/presentation/flame/flame_animation.dart';

typedef AnimationFactoryFunction = Animation Function();

class ParticleSpriteResolver extends SpriteResolver {
  static Map<String, AnimationFactoryFunction> _animations;
  String _name;

  ParticleSpriteResolver(String name) {
    _name = name;
    if (_animations == null) {
      _animations = Map<String, AnimationFactoryFunction>();
      _animations['particle_damage01'] = () {
        return FlameAnimation(AnimationDefinition(
            'particle_damage01.png', 20, 20, 20, 3, 1, 0.1,
            anchorPoint: AnchorPoint.MIDDLE_CENTER, loop: false));
      };
    }
  }

  @override
  Sprite resolve(SpriteContext context) {
    return null;
  }

  @override
  Animation resolveAnimation(SpriteContext context) {
    return _animations[_name]() ?? null;
  }

  @override
  void update() {}
}
