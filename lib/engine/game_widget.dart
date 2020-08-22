import 'dart:math';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'entity/base_entity_factory.dart';
import 'entity/direct_rendering.dart';
import 'entity/entity.dart';
import 'global_event.dart';
import 'input_event.dart';
import 'scene/scene.dart';
import 'screen.dart';
import 'world.dart';

/// ユーザーからの入力を受け付け、GameModelに伝える
/// GameModelの内容をレンダリングする
class GameWidget extends Game with GlobalEventListener {
  bool _initialized = false;
  Scene _scene;
  World _world;
  double _worldW;
  double _worldH;
  double _worldD;
  double _gameW;
  double _gameH;
  double _deviceW;
  double _deviceH;
  ScreenAdjustment _screenAdjustment;
  BaseEntityFactory _entityFactory;

  GameWidget()
      : _deviceW = 0,
        _deviceH = 0;

  Future<void> initialize(double gameW, double gameH, double worldW,
      double worldH, double worldD, BaseEntityFactory entityFactory) async {
    await Flame.util.fullScreen();
    await Flame.util.setLandscape();
    await Flame.util.initialDimensions();
    Size deviceSize = await Flame.util.initialDimensions();
    _entityFactory = entityFactory;
    _deviceW = max(deviceSize.width, deviceSize.height);
    _deviceH = min(deviceSize.height, deviceSize.width);
    _gameW = gameW;
    _gameH = gameH;
    _worldW = worldW;
    _worldH = worldH;
    _worldD = worldD;
    _screenAdjustment = ScreenAdjustment(_gameW, _gameH, _deviceW, _deviceH);

    _world = World(worldW, worldH, worldD, _screenAdjustment, entityFactory);
    GlobalEventBus.instance().addListener(this as GlobalEventListener);
    _initialized = true;
  }

  void setScene(Scene newScene) {
    _scene = newScene;
    _world =
        World(_worldW, _worldH, _worldD, _screenAdjustment, _entityFactory);
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

    if (_scene == null) {
      _world.update(dt);
    }

    _scene.update(_world.context, _world.camera);
    _world.update(dt);
  }

  @override
  void render(Canvas canvas) {
    if (!_initialized) {
      return;
    }

    if (_scene != null) {
      if (!_scene.isNeedRendering()) {
        return;
      }
    }

    if (_world.context.getBackground() != null) {
      _world.context.getBackground().render(canvas, _world.camera);
    }

    _world.entities.whereLayer('default').forEach((entity) {
      //TODO: 0件の場合1件目がnullになる問題を解消する
      entity?.getSprites()?.forEach((sprite) {
        sprite.render(canvas, _world.camera, convertZtoY: true);
      });
    });
    _world.entities.whereLayer('hud').forEach((entity) {
      if (entity is DirectRendering) {
        (entity as DirectRendering)
            .getRenderer()
            .render(canvas, _world.camera, entity);
        return;
      }

      entity?.getSprites()?.forEach((sprite) {
        sprite.render(canvas, _world.camera, affectScroll: false);
      });
    });

    _world.entities.whereLayer('ui').forEach((entity) {
      if (entity is DirectRendering) {
        (entity as DirectRendering)
            .getRenderer()
            .render(canvas, _world.camera, entity);
        return;
      }

      entity?.getSprites()?.forEach((sprite) {
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

    _scene?.render(canvas, _world.camera);
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

  @override
  void onGlobalEvent(WorldContext context, GlobalEvent event) {
    switch (event.type) {
      case 'change_scene':
        _scene.leave(() {
          setScene(event.payload['new_scene']);
        });
        break;
    }
  }
}
