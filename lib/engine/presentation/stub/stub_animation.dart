import '../../image/animation.dart';
import '../../image/sprite.dart';
import 'stub_sprite.dart';

class StubAnimation extends Animation {
  double x;
  double y;
  double z;
  double w;
  double h;
  double d;

  StubAnimation(this.x, this.y, this.z, this.w, this.h, this.d);

  @override
  Sprite getSprite() {
    return StubSprite(x, y, z, w, h, d);
  }

  @override
  bool isDone() {
    return true;
  }

  @override
  bool isLoaded() {
    return true;
  }

  @override
  bool isLoop() {
    return false;
  }

  @override
  void update({AnimationEventCallback animationEventCallback}) {}
}
