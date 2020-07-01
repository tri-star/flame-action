import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_action/domain/entity/entity.dart';
import 'package:flame_action/presentation/flame/flame_sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'entity/base_entity_factory.dart';
import 'joystick.dart';
import 'world.dart';

/// ユーザーからの入力を受け付け、GameModelに伝える
/// GameModelの内容をレンダリングする
class GameWidget extends Game {
  bool _initialized = false;
  World _world;
  double _deviceW;
  double _deviceH;

  GameWidget()
      : _deviceW = 0,
        _deviceH = 0;

  Future<void> initialize(double worldW, double worldH, double worldD,
      BaseEntityFactory entityFactory) async {
    await Flame.util.setLandscape();
    await Flame.util.fullScreen();
    await Flame.util.initialDimensions();
    Size deviceSize = await Flame.util.initialDimensions();
    _deviceW = deviceSize.width;
    _deviceH = deviceSize.height;

    _world = World(worldW, worldH, worldD, deviceSize.width, deviceSize.height,
        entityFactory);
    _initialized = true;
  }

  void setBackground(String fileName) {
    _world.setBackground(FlameSprite(Sprite(fileName),
        x: 0, y: 0, z: 0, d: 1)); // Flameを直接使わないようにする
  }

  void addEntity(Entity entity) {
    _world.addEntity(entity);
  }

  void createJoystick(double x, double y) {
    _world.createJoystick(x, y);
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
      entity.getSprites().forEach((sprite) {
        sprite.render(canvas, null);
      });
    });
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
