import 'sprite.dart';

abstract class Animation {

  /// 現在のフレームのスプライトを返す
  Sprite getSprite();

  /// アニメーションを1tick分進める
  void update();

  /// ロードされているかを返す
  bool isLoaded();

  /// ループ再生するかどうかを返す
  bool isLoop();

  ///アニメーションが終了したかどうかを返す
  bool isDone();
}
