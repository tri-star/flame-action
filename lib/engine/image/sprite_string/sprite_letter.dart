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
    this.bounceFactor = 0.5;
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
    context?.collisionDetectService?.detect(context, this, collisionEvent);
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

  void onCollide(WorldContext context, CollisionEvent event) {
    super.onCollide(context, event);
    if (event.type == 'collide') {
      Rect3d sourceRect = event.source.getRect();
      Rect3d ownRect = getRect();
      if (event.source.getTags().contains("obstacle")) {
        if (ownRect.getIntersectDimension(sourceRect) ==
            IntersectDimension.BOTTOM) {
          if (gravityFlag) {
            vx *= bounceFactor;
            vz *= bounceFactor;
          }
        }
      }
    }
  }
}
