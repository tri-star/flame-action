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
  List<TimeoutTimer> _letterTimers;

  static const double LETTER_SPEED = 0.08;
  static const double LETTER_LIFETIME = 1.0;
  static const double CHARACTER_WIDTH = 10;
  static const double LETTER_SPACING = 2.0;
  static const double OFFSET_Y = -40.0;
  static const double FORCE_X = 2.0;
  static const double FORCE_Y = -7;
  static const double FORCE_Z = 0;
  static const double BOUNCE_FACTOR = 0.5;

  PopWithGravityString(int id, String message, double x, double y, double z,
      {String fontName})
      : super(id, message, x, y, z, fontName: fontName) {
    assert(message != null && message != '');

    _letters = List<SpriteLetter>();
    _letterTimers = List<TimeoutTimer>();
    int count = 0;
    message.split('').forEach((String letter) {
      SpriteLetter spriteLetter = SpriteLetter(0, letter,
          x + (count * CHARACTER_WIDTH) + LETTER_SPACING, y + OFFSET_Y, z,
          gravityFlag: true, collidableFlag: true, bounceFactor: BOUNCE_FACTOR);
      spriteLetter.addForce(FORCE_X, FORCE_Y, FORCE_Z);
      _letters.add(spriteLetter);
      count++;
    });
    _timer = TimeoutTimer(LETTER_SPEED);
  }

  @override
  void update(double dt, WorldContext context) {
    _timer.update();
    if (_timer.isDone() && current < _letters.length) {
      SpriteLetter entity = _letters[current];
      context.addEntity(entity);
      _letterTimers.add(TimeoutTimer(LETTER_LIFETIME, callback: () {
        entity.dispose();
      }));

      current++;
      _timer.reset();
    }

    bool allLetterDisposed = true;
    _letterTimers.forEach((timer) {
      timer.update();
      if (!timer.isDone()) {
        allLetterDisposed = false;
      }
    });
    if (current >= _letters.length && allLetterDisposed) {
      dispose();
    }
  }

  @override
  double getW() => 1;
  @override
  double getH() => 1;
  @override
  double getD() => 1;

  @override
  Rect3d getRect() {
    return Rect3d(x, y, z, getW(), getH(), getD());
  }

  List<Sprite> getSprites() {
    return [];
  }
}
