import 'dart:ui';

import 'package:flame/spritesheet.dart';

import '../../image/sprite.dart';
import '../../image/sprite_font.dart';
import 'flame_sprite.dart';

class FlameSpriteFont extends SpriteFont {
  SpriteSheet _spriteSheet;

  FlameSpriteFont(String fileName, double w, double h, int cols, int rows,
      {SpriteFontType type = SpriteFontType.CHARACTER, String layer}) {
    _spriteSheet = SpriteSheet(
      imageName: fileName,
      textureWidth: w.toInt(),
      textureHeight: h.toInt(),
      columns: cols,
      rows: rows,
    );
    this.w = w;
    this.h = h;
    this.fileName = fileName;
    this.cols = cols;
    this.rows = rows;
    this.type = type;
  }

  @override
  Sprite getSprite(String char) {
    int offset = char.codeUnitAt(0) - '0'.codeUnitAt(0);
    return FlameSprite(_spriteSheet.getSprite(0, offset), w: w, h: h)
      ..anchor = AnchorPoint.BOTTOM_LEFT;
  }

  @override
  void renderString(Canvas canvas, String char) {
    // TODO: implement renderString
  }
}
