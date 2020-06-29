import 'package:flame_action/engine/image/sprite_font.dart';

import '../../../domain/entity/entity.dart';
import '../../coordinates.dart';
import '../../services/collision_detect_service.dart';
import '../../world.dart';
import '../sprite.dart';

/// スプライト文字列の1文字分を表示するEntity
class SpriteLetter extends Entity {
  String _fontName;

  String _char;

  SpriteFont _font;

  SpriteLetter(int id, String char, double x, double y, double z,
      {String fontName})
      : _char = char,
        _fontName = fontName ?? 'default' {
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = z;
    this.bounceFactor = 0.6;
    this.gravityFlag = true;
    this.collidableFlag = true;
    _font = SpriteFontRegistry().get(_fontName);
  }

  @override
  void update(double dt, WorldContext context) {
    if (gravityFlag) {
      vy += 0.98;
    }

    x += vx;
    y += vy;
    z += vz;

    CollisionEvent collisionEvent = CollisionEvent('collide', this);
    context?.collisionDetectService?.detect(this, collisionEvent);
  }

  @override
  double getW() => _font.getW();
  @override
  double getH() => _font.getH();
  @override
  double getD() => 1;

  @override
  Rect3d getRect() {
    double offsetX = _font.getSprite(_char).getOffsets().x;
    double offsetY = _font.getSprite(_char).getOffsets().y;
    double offsetZ = _font.getSprite(_char).getOffsets().z;
    return Rect3d(
        x + offsetX, y + offsetY, z + offsetZ, getW(), getH(), getD());
  }

  List<Sprite> getSprites() {
    return [
      _font.getSprite(_char)
        ..x = x
        ..y = y
        ..z = z + 5
    ];
  }
}
