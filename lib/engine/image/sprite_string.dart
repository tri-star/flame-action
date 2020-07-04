import 'package:flutter/foundation.dart';

import '../entity/entity.dart';
import '../services/collision_detect_service.dart';
import '../world.dart';
import 'sprite.dart';

/// 文字列を1文字単位で座標管理する必要がある場合に使用する
abstract class SpriteString extends Entity {
  @protected
  String fontName;

  @protected
  String message;

  int _length;

  SpriteString(int id, this.message, double x, double y, double z,
      {this.fontName}) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.z = z;
  }

  @protected
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

  @protected
  double getW() => 0;
  @protected
  double getH() => 0;
  @protected
  double getD() => 0;

  List<Sprite> getSprites() {
    return [];
  }
}
