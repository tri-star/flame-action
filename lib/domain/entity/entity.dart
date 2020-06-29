import 'package:flame_action/engine/coordinates.dart';
import 'package:flame_action/engine/image/animation.dart';
import 'package:flame_action/engine/image/sprite.dart';
import 'package:flame_action/engine/image/sprite_resolver.dart';
import 'package:flame_action/engine/services/collision_detect_service.dart';
import 'package:flutter/foundation.dart';

import '../../engine/world.dart';

enum Dimension { LEFT, RIGHT }

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

  /// 重力の影響を受けるかどうか
  @protected
  bool gravityFlag = false;

  /// 衝突判定を行うかどうか
  @protected
  bool collidableFlag = false;

  /// 衝突した場合、跳ね返る際の係数
  @protected
  double bounceFactor = 0;

  void update(double dt, WorldContext context) {
    if (gravityFlag) {
      vy += 0.98;
    }

    x += vx;
    y += vy;
    z += vz;

    updateState();
    updateAnimation();
    animation?.update(animationEventCallback: (AnimationFrameEvent event) {
      onAnimationEvent(context, event);
    });

    CollisionEvent collisionEvent = CollisionEvent('collide', this);
    context?.collisionDetectService?.detect(context, this, collisionEvent);
  }

  void updateState() {
    if (animation?.isDone() ?? false) {
      state = getNextState(state);
    }
  }

  void updateAnimation() {
    if (spriteResolver == null) {
      return;
    }
    Animation newAnimation = spriteResolver
        .resolveAnimation(SpriteContext(state: state, dimension: dimension));
    if (animation != newAnimation) {
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
  List<String> getTags() => tags;
  Dimension getDimension() => dimension;
  bool haveGravity() => gravityFlag;
  bool isCollidable() => collidableFlag;

  List<Sprite> getSprites() {
    if (animation == null) {
      return [];
    }
    Sprite sprite = animation.getSprite();
    if (sprite == null) {
      return [];
    }
    sprite
      ..x = x
      ..y = y
      ..z = z
      ..dimension = dimension;

    return List<Sprite>.from([sprite]);
  }

  Rect3d getRect() {
    double offsetX = animation?.getSprite()?.getOffsets()?.x ?? 0;
    double offsetY = animation?.getSprite()?.getOffsets()?.y ?? 0;
    double offsetZ = animation?.getSprite()?.getOffsets()?.z ?? 0;
    return Rect3d(
        x + offsetX, y + offsetY, z + offsetZ, getW(), getH(), getD());
  }

  Position3d getPosition() {
    return Position3d(x, y, z);
  }

  void addZ(double distance) {
    z += distance;
  }

  void disableGravity() {
    gravityFlag = false;
  }

  void addAdjustment(Vector3d vector) {
    x += vector.x;
    y += vector.y;
    z += vector.z;
  }

  void addForce(double x, double y, double z) {
    vx += x;
    vy += y;
    vz += z;
  }

  String getNextState(String currentState) {
    return 'neutral';
  }

  void onCollide(WorldContext context, CollisionEvent event) {
    if (event.type == 'collide') {
      Rect3d sourceRect = event.source.getRect();
      Rect3d ownRect = getRect();
      Vector3d adjustment = ownRect.getIntersectAdjustment(sourceRect);
      if (event.source.getTags().contains("obstacle")) {
        if (event.intersectDimension == IntersectDimension.BOTTOM) {
          if (gravityFlag) {
            vy *= -(bounceFactor.abs());
          }
        }
        addAdjustment(adjustment);
      }
    }
  }

  void onAnimationEvent(WorldContext context, AnimationFrameEvent event) {}
}
