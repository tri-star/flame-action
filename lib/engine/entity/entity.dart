import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../../util/coordinates.dart';
import '../coordinates.dart';
import '../image/animation.dart';
import '../image/sprite.dart';
import '../image/sprite_resolver.dart';
import '../services/collision_detect_service.dart';
import '../world.dart';

enum Dimension { LEFT, RIGHT }

/// キャラクターやパーティクル、障害物、アイテムなど
/// ゲーム中に登場するオブジェクトのベースになるクラス
class Entity {
  /// エンティティを一意に特定するID
  @protected
  int id = 0;

  /// エンティティの種類を特定する名前。
  /// (EntityFactoryで生成時に指定するキー名)
  @protected
  String entityName = '';

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

  /// レンダリング先のレイヤー名。
  @protected
  String layer = 'default';

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

  void update(WorldContext context) {
    if (gravityFlag) {
      vy += 0.98;
    }

    x += vx;
    y += vy;
    z += vz;

    updateState();
    animation?.update(animationEventCallback: (AnimationFrameEvent event) {
      onAnimationEvent(context, event);
    });

    CollisionEvent collisionEvent = CollisionEvent('collide', this);
    context?.collisionDetectService?.detect(context, this, collisionEvent);
  }

  /// 状態が変更可能か確認してから変更を行う。
  /// 変更できなかった場合はfalseを返す。
  bool changeState(String newState) {
    setState(newState);
    return true;
  }

  String getState() => state;

  void setState(String newState) {
    state = newState;
    if (state == 'disposed') {
      return;
    }
    animation = spriteResolver
        .resolveAnimation(SpriteContext(state: state, dimension: dimension));
  }

  void updateState() {
    if (getAnimation()?.isDone() ?? false) {
      setState(getNextState(state));
    }
  }

  @protected
  Animation getAnimation() {
    if (animation == null) {
      animation = spriteResolver
          ?.resolveAnimation(SpriteContext(state: state, dimension: dimension));
    }
    return animation;
  }

  int getId() => id;
  String getEntityName() => entityName;
  String getLayer() => layer;
  double getX() => x;
  double getY() => y;
  double getZ() => z;
  double getW() => getAnimation()?.getSprite()?.w ?? 0;
  double getH() => getAnimation()?.getSprite()?.h ?? 0;
  double getD() => getAnimation()?.getSprite()?.d ?? 0;
  List<String> getTags() => tags;
  Dimension getDimension() => dimension;
  bool haveGravity() => gravityFlag;
  bool isCollidable() => collidableFlag;
  bool isOverwrappedZ(Rect3d targetRect) {
    Rect3d rect = getRect();
    return CoordinateUtil.isLineOverwrapped(
        rect.z, rect.d, targetRect.z, targetRect.d);
  }

  List<Sprite> getSprites() {
    Animation currentAnimation = getAnimation();
    if (currentAnimation == null) {
      return [];
    }
    Sprite sprite = currentAnimation?.getSprite();
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
    Animation currentAnimation = getAnimation();
    double offsetX = currentAnimation?.getSprite()?.getOffsets()?.x ?? 0;
    double offsetY = currentAnimation?.getSprite()?.getOffsets()?.y ?? 0;
    double offsetZ = currentAnimation?.getSprite()?.getOffsets()?.z ?? 0;
    return Rect3d(
        x + offsetX, y + offsetY, z + offsetZ, getW(), getH(), getD());
  }

  /// 描画用に2次元に変換した矩形を返す
  Rect getRenderRect() {
    Animation currentAnimation = getAnimation();
    double offsetX = currentAnimation?.getSprite()?.getOffsets()?.x ?? 0;
    double offsetY = currentAnimation?.getSprite()?.getOffsets()?.y ?? 0;
    double offsetZ = currentAnimation?.getSprite()?.getOffsets()?.z ?? 0;
    return Rect.fromLTWH(
        x + offsetX, (y + offsetY) + (z + offsetZ), getW(), getH());
  }

  Position3d getPosition() {
    return Position3d(x, y, z);
  }

  void addZ(double distance) {
    z += distance;
  }

  void enableGravity() {
    gravityFlag = true;
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

    if (vy < 0) {
      this.y += vy;
    }
  }

  void setForce({double x, double y, double z}) {
    if (x != null) {
      vx = x;
    }
    if (y != null) {
      vy = y;
    }
    if (z != null) {
      vz = z;
    }
    if (vy < 0) {
      this.y += vy;
    }
  }

  void setLocation({double x, double y, double z}) {
    if (x != null) {
      this.x = x;
    }
    if (y != null) {
      this.y = y;
    }
    if (z != null) {
      this.z = z;
    }
  }

  void setDimension(Dimension newDimension) => dimension = newDimension;

  void setLayer(String layer) {
    this.layer = layer;
  }

  /// Entityを削除可能な状態にする
  void dispose() {
    state = 'disposed';
  }

  bool isDisposed() {
    return state == 'disposed';
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
