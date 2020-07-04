import 'package:flame_action/presentation/flame/flame_animation.dart';
import '../../engine/image/animation.dart';
import '../../engine/image/sprite.dart';
import '../../engine/image/sprite_resolver.dart';

class JoyStickSpriteResolver extends SpriteResolver {
  Map<String, Animation> _animations;

  JoyStickSpriteResolver() {
    _animations = Map<String, FlameAnimation>();
    _animations['base'] = FlameAnimation(AnimationDefinition(
        'joystick_base.png', 140, 140, 1, 1, 1, 0.1,
        anchorPoint: AnchorPoint.MIDDLE_CENTER));
    _animations['knob'] = FlameAnimation(AnimationDefinition(
        'joystick_knob.png', 60, 60, 1, 1, 1, 0.1,
        anchorPoint: AnchorPoint.MIDDLE_CENTER));
  }

  @override
  Sprite resolve(SpriteContext context) {
    return null;
  }

  @override
  Animation resolveAnimation(SpriteContext context) {
    return _animations[context.state] ?? null;
  }

  @override
  void update() {
    return;
  }
}
