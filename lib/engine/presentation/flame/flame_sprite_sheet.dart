import 'package:flame/spritesheet.dart' as Flame;
import '../../../engine/image/sprite_sheet.dart';
import '../../../engine/image/sprite.dart';
import 'flame_sprite.dart';

class FlameSpriteSheet extends SpriteSheet {
  Flame.SpriteSheet _flameSpriteSheet;

  FlameSpriteSheet(
      String fileName, int frameWidth, int frameHeight, int cols, int rows) {
    this.fileName = fileName;
    this.frameWidth = frameWidth;
    this.frameHeight = frameHeight;
    this.cols = cols;
    this.rows = rows;
    this._flameSpriteSheet = Flame.SpriteSheet(
        imageName: fileName,
        textureWidth: frameWidth,
        textureHeight: frameHeight,
        columns: cols,
        rows: rows);
  }

  Sprite getSpriteByIndex(int index) {
    int row = index ~/ cols;
    int column = index % cols;
    return FlameSprite(_flameSpriteSheet.getSprite(row, column),
        w: frameWidth.toDouble(), h: frameHeight.toDouble());
  }
}
