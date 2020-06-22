
import 'package:flame_action/engine/coordinates.dart';
import 'package:flame_action/engine/image/animation.dart';
import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
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
  SpriteResolver spriteResolver;

  @protected
  Animation animation;

  @protected
  List<String> tags = List<String>();

  void update(double dt) {
    x += vx;
    y += vy;
    z += vz;

    updateState();
    updateAnimation();
    animation?.update();
  }

  void updateState() {
    if(animation?.isDone() ?? false) {
      state = getNextState(state);
    }
  }

  void updateAnimation() {
    if(spriteResolver == null) {
      return;
    }
    Animation newAnimation = spriteResolver.resolveAnimation(SpriteContext(state: state, dimension: dimension));
    if(animation != newAnimation) {
      animation = newAnimation;
    }
  }

  int getId() => id;
  double getX() => x;
  double getY() => y;
  double getZ() => z;
  double getW() => animation?.getSprite()?.w ?? 0;
  double getH() => animation?.getSprite()?.h ?? 0;
  double getD() => animation?.getSprite()?.d ?? 0;
  Dimension getDimension() => dimension;

  List<Sprite> getSprites() {
    return null;    
  }

  Rect3d getRect() {
    return Rect3d(x, y, z, getW(), getH(), getD());
  }

  Position3d getPosition() {
    return Position3d(x, y, z);    
  }

  void addZ(double distance) {
    z += distance;
  }

  void addAdjustment(Vector3d vector) {
    x += vector.x;
    y += vector.y;
    z += vector.z;
  }

  String getNextState(String currentState) {
    return 'neutral';
  }
}
