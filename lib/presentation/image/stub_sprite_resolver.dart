import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/animation.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/presentation/stub/stub_animation.dart';

class StubSpriteResolver extends SpriteResolver {
  double x = 0;
  double y = 0;
  double z = 0;
  double w = 0;
  double h = 0;
  double d = 1;

  StubSpriteResolver({this.x, this.y, this.z, this.w, this.h, this.d});

  @override
  Sprite resolve(SpriteContext context) {}

  @override
  Animation resolveAnimation(SpriteContext context) {
    return StubAnimation(x, y, z, w, h, d);
  }

  @override
  void update() {}
}
