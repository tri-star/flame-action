
import 'package:flame_action/engine/image/sprite.dart';
import 'package:flutter/foundation.dart';

enum Dimension {
  LEFT,
  RIGHT
}

/// キャラクターやパーティクル、障害物、アイテムなど
/// ゲーム中に登場するオブジェクトのベースになるクラス
class Entity {
  
  /// エンティティを一意に特定するID
  @protected
  int id = 0;

  @protected
  double x = 0;
  @protected
  double y = 0;
  @protected
  double z = 0;

  @protected
  double vx = 0;
  @protected
  double vy = 0;
  @protected
  double vz = 0;

  @protected
  Dimension dimension = Dimension.RIGHT;

  @protected
  String state = 'neutral';

  @protected
  List<String> tags = List<String>();

  void update(double dt) {
    throw new UnimplementedError();
  }

  int getId() => id;
  double getX() => x;
  double getY() => y;
  double getZ() => z;
  Dimension getDimension() => dimension;

  List<Sprite> getSprites() {
    return null;    
  }

  void addZ(double distance) {
    z += distance;
  }
}
