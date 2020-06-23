import 'package:flutter/foundation.dart';

import 'sprite.dart';

/// アニメーションの定義情報
class AnimationDefinition {
  String fileName;
  int width;
  int height;
  double depth;
  int cols;
  int rows;
  double frameSpeed;
  int startRow;
  AnchorPoint anchorPoint;
  bool loop;

  AnimationDefinition(this.fileName, this.width, this.height, this.depth, this.cols, this.rows, this.frameSpeed, {this.startRow=0, this.anchorPoint=AnchorPoint.TOP_LEFT, this.loop=true});
}

abstract class Animation {

  @protected
  AnimationDefinition definition;

  @protected
  int currentIndex;

  @protected
  Sprite currentSprite;


  /// 現在のフレームのスプライトを返す
  Sprite getSprite();

  /// アニメーションを1tick分進める
  void update();

  /// ロードされているかを返す
  bool isLoaded();

  /// ループ再生するかどうかを返す
  bool isLoop() {
    return definition.loop;
  }

  ///アニメーションが終了したかどうかを返す
  bool isDone();
}
