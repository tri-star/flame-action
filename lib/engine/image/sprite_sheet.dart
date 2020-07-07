import 'package:flutter/foundation.dart';

import 'sprite.dart';

abstract class SpriteSheet {
  @protected
  String fileName;
  @protected
  int frameWidth;
  @protected
  int frameHeight;

  @protected
  int cols;
  @protected
  int rows;

  Sprite getSpriteByIndex(int index);
}
