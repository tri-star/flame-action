import '../../../engine/image/sprite_string.dart';
import '../../../util/timer.dart';
import '../../coordinates.dart';
import '../../world.dart';
import '../sprite.dart';
import 'sprite_letter.dart';

/// 飛び出す動作をしながら重力の影響を受けて表示される文字列
class PopWithGravityString extends SpriteString {
  List<SpriteLetter> _letters;
  int current = 0;
  TimeoutTimer _timer;

  PopWithGravityString(int id, String message, double x, double y, double z,
      {String fontName})
      : super(id, message, x, y, z, fontName: fontName) {
    _letters = List<SpriteLetter>();
    int count = 0;
    message.split('').forEach((String letter) {
      SpriteLetter spriteLetter =
          SpriteLetter(0, letter, x + (count * 10) + 1, y, z + count);
      _letters.add(spriteLetter);
      count++;
    });
    _timer = TimeoutTimer(0.08);
  }

  @override
  void update(double dt, WorldContext context) {
    if (current >= _letters.length) {
      return;
    }
    _timer.update();
    if (_timer.isDone()) {
      context.addEntity(_letters[current]);
      current++;
      _timer.reset();
    }
  }

  @override
  double getW() => 10;
  @override
  double getH() => 12;
  @override
  double getD() => 10;

  @override
  Rect3d getRect() {
    return Rect3d(x, y, z, getW(), getH(), getD());
  }

  List<Sprite> getSprites() {
    return [];
  }
}
