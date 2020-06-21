import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flame_action/presentation/flame/flame_sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'joystick.dart';
import 'world.dart';
import '../domain/entity/enemy.dart';
import '../domain/entity/player.dart';
import '../presentation/image/enemy_sprite_resolver.dart';
import '../presentation/image/player_sprite_resolver.dart';

/// ユーザーからの入力を受け付け、GameModelに伝える
/// GameModelの内容をレンダリングする
class GameWidget extends Game {

  bool _initialized = false;
  World _world;

  GameWidget() {
    _initialize();
  }

  _initialize() async {
    await Flame.util.setLandscape();
    await Flame.util.fullScreen();
    await Flame.util.initialDimensions();
    Size dimension = await Flame.util.initialDimensions();
    Player player = Player(1, PlayerSpriteResolver(),  x: 10, y: 200, z: 40);

    _world = World(2000, 340, dimension.width, dimension.height);
    _world.setBackground(FlameSprite(Sprite('background01.png'), x: 0, y: 0));  // Flameを直接使わないようにする
    _world.addEntity(player);
    _world.addEntity(Enemy(2, EnemySpriteResolver(), x: 1200, y: 200, z: 50));
    
    _world.createJoystick(60, 300);
    _world.camera.followEntity(player);
    _initialized = true;
  }

  Widget getWidget() {
    return Listener(
      onPointerMove: onPointerMove,
      onPointerUp: onPointerUp,
      onPointerDown: onPointerDown,
      child: widget
    );
  }

  @override
  void update(double dt) {
    if(!_initialized) {
      return;
    }
    _world.update(dt);
  }

  @override
  void render(Canvas canvas) {
    if(!_initialized) {
      return;
    }

    if(_world.background != null) {
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
    final pointerEvent = UiPointerEvent(PointerEventType.UPDATE, event.pointer, event.position.dx, event.position.dy);
    _world.onPointerEvent(pointerEvent);
  }

  void onPointerDown(PointerDownEvent event) {
    final pointerEvent = UiPointerEvent(PointerEventType.START, event.pointer, event.position.dx, event.position.dy);
    _world.onPointerEvent(pointerEvent);
  }

  void onPointerUp(PointerUpEvent event) {
    final pointerEvent = UiPointerEvent(PointerEventType.END, event.pointer, event.position.dx, event.position.dy);
    _world.onPointerEvent(pointerEvent);
  }
}
