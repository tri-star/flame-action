import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'sprite.dart';


class SpriteFontRegistry {
  Map<String, SpriteFont> _fonts;

  static final SpriteFontRegistry _instance = new SpriteFontRegistry._internal();

  factory SpriteFontRegistry() => _instance;

  SpriteFontRegistry._internal():
    _fonts = Map<String, SpriteFont>();

  register(String key, SpriteFont font) {
    _fonts[key] = font;
  }

  SpriteFont get(String key) {
    if(!_fonts.containsKey(key)) {
      throw UnsupportedError('無効なフォント名が指定されました: $key');
    }
    return _fonts[key];
  }

}


enum SpriteFontType {
  CHARACTER,
  NUMBER
}


abstract class SpriteFont {
  @protected
  String fileName;

  @protected
  double w;

  @protected
  double h;

  @protected
  int cols;

  @protected
  int rows;

  @protected
  SpriteFontType type;

  @protected
  Sprite sprite;

  double getW() => w;
  double getH() => h;
  SpriteFontType getType() => type;

  /// 指定した文字に対応するSpriteを返す
  Sprite getSprite(String char);
  
  /// 渡された文字列を現在のフォントで出力する
  void renderString(Canvas canvas, String string);
}
