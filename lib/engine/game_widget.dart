import 'dart:math';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_action/engine/entity/entity.dart';
import 'package:flame_action/engine/screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'entity/base_entity_factory.dart';
import 'entity/direct_rendering.dart';
import 'presentation/flame/flame_sprite.dart';
import 'input_event.dart';
import 'world.dart';

/// ユーザーからの入力を受け付け、GameModelに伝える
/// GameModelの内容をレンダリングする
class GameWidget extends Game {
  bool _initialized = false;
  World _world;
  double _gameW;
  double _gameH;
  double _deviceW;
  double _deviceH;
  ScreenAdjustment _screenAdjustment;

  GameWidget()
      : _deviceW = 0,
        _deviceH = 0;

  Future<void> initialize(double gameW, double gameH, double worldW,
      double worldH, double worldD, BaseEntityFactory entityFactory) async {
    await Flame.util.fullScreen();
    await Flame.util.setLandscape();
    await Flame.util.initialDimensions();
    Size deviceSize = await Flame.util.initialDimensions();
    _deviceW = max(deviceSize.width, deviceSize.height);
    _deviceH = min(deviceSize.height, deviceSize.width);
    _gameW = gameW;
    _gameH = gameH;
    _screenAdjustment = ScreenAdjustment(_gameW, _gameH, _deviceW, _deviceH);

    _world = World(worldW, worldH, worldD, _screenAdjustment, entityFactory);
    _initialized = true;
  }

  void setBackground(String fileName, double w, double h) {
    _world.setBackground(FlameSprite(Sprite(fileName),
        x: 0, y: 0, z: 0, w: w, h: h, d: 1)); // Flameを直接使わないようにする
  }

  void addEntity(Entity entity) {
    _world.addEntity(entity);
  }

  void addHud(Entity entity) {
    _world.addHud(entity);
  }

  void addUnit(Entity entity) {
    _world.addUnit(entity);
  }

  void setCameraFocus(Entity entity) {
    _world.camera.followEntity(entity);
  }

  double getDeviceWidth() => _deviceW;
  double getDeviceHeight() => _deviceH;

  Widget getWidget() {
    return Listener(
        onPointerMove: onPointerMove,
        onPointerUp: onPointerUp,
        onPointerDown: onPointerDown,
        child: widget);
  }

  @override
  void update(double dt) {
    if (!_initialized) {
      return;
    }
    _world.update(dt);
  }

  @override
  void render(Canvas canvas) {
    if (!_initialized) {
      return;
    }

    if (_world.background != null) {
      _world.background.render(canvas, _world.camera);
    }

    _world.entities.forEach((entity) {
      entity.getSprites().forEach((sprite) {
        sprite.render(canvas, _world.camera);
      });
    });
    _world.huds.forEach((entity) {
      if (entity is DirectRendering) {
        (entity as DirectRendering)
            .getRenderer()
            .render(canvas, _world.camera, entity);
        return;
      }

      entity.getSprites().forEach((sprite) {
        sprite.render(canvas, _world.camera, affectScroll: false);
      });
    });

    canvas.drawRect(
        Rect.fromLTWH(0, 0, _world.camera.getRenderX(0, affectScroll: false),
            _world.camera.h),
        Paint()..color = Colors.black);
    canvas.drawRect(
        Rect.fromLTWH(
            _world.camera.getRenderX(_world.camera.w, affectScroll: false),
            0,
            _world.camera.getRenderX(0, affectScroll: false),
            _world.camera.h),
        Paint()..color = Colors.black);
  }

  void onPointerMove(PointerMoveEvent event) {
    final pointerEvent = UiPointerEvent(PointerEventType.UPDATE, event.pointer,
        event.position.dx, event.position.dy);
    _world.onPointerEvent(pointerEvent);
  }

  void onPointerDown(PointerDownEvent event) {
    final pointerEvent = UiPointerEvent(PointerEventType.START, event.pointer,
        event.position.dx, event.position.dy);
    _world.onPointerEvent(pointerEvent);
  }

  void onPointerUp(PointerUpEvent event) {
    final pointerEvent = UiPointerEvent(PointerEventType.END, event.pointer,
        event.position.dx, event.position.dy);
    _world.onPointerEvent(pointerEvent);
  }
}
