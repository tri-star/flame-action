
import 'package:flame_action/domain/entity/entity.dart';
import 'package:flame_action/domain/entity/joystick.dart';
import 'package:flame_action/presentation/image/joystick_sprite_resolver.dart';
import 'package:flutter/painting.dart';

import 'image/sprite.dart';
import 'joystick.dart';

/// ゲームの本体。
/// ユーザーの入力などをデバイスに依存しない形で受け付ける
/// World単位でスローモーションにしたり高速化するなど
/// 時間軸を変更することが可能で、Worldはゲーム内に複数存在する可能性がある
class World implements JoystickListener {

  Sprite background;
  Entity _entity;
  List<Entity> _entities;
  PointerEventHandler _pointerEventHandler;

  int _randomSeed;  

  World({randomSeed: 0}): 
    _randomSeed = randomSeed,
    _entities = List<Entity>();

  void update(double dt) {
    _entities.forEach((entity) {
      entity.update(dt);
    });
  }

  void addEntity(Entity entity) {
    _entity = entity;
    _entities.add(entity);
  }

  void createJoystick(double x, double y) {
    // 横幅/縦幅またはRectの情報をEntityやSpriteから取得する
    _pointerEventHandler = PointerEventHandler(Rect.fromLTWH(x-40.0, y-40.0, 80, 80));;
    _pointerEventHandler.addListener('world', this);

    this.addEntity(JoyStick(JoyStickSpriteResolver(), x: x, y: y));
  }

  void setBackground(Sprite _sprite) {
    background = _sprite;
  }

  /// 画面からのポインタに関するイベントを受け取る
  void onPointerEvent(UiPointerEvent uiPointerEvent) {
    _pointerEventHandler.handle(uiPointerEvent);
  }

  /// UIからのイベントをJoystickのイベントに変換した結果を受け取る
  @override
  onJoystickMove(JoystickMoveEvent event) {
    _entities.forEach((entity) {
      if(entity is JoystickListener) {
        (entity as JoystickListener).onJoystickMove(event);
      }
    });
  }

  Entity get entity => _entity;
  List<Entity> get entities => _entities;
}
