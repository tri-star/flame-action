
import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';

/// キャラクターやパーティクル、障害物、アイテムなど
/// ゲーム中に登場するオブジェクトのベースになるクラス
class Entity {
  
  /// エンティティを一意に特定するID
  @protected
  String id = '';

  @protected
  double x = 0;
  @protected
  double y = 0;

  @protected
  double vx = 0;
  @protected
  double vy = 0;

  @protected
  String state = 'neutral';

  @protected
  List<String> tags = List<String>();

  void update(double dt) {
    throw new UnimplementedError();
  }

  //TODO: Flameに依存しないようにする
  Sprite get sprite => null;

  double getX() => x;
  double getY() => y;
}
