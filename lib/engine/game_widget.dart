import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'joystick.dart';
import 'world.dart';
import '../domain/entity/enemy.dart';
import '../domain/entity/player.dart';
import '../presentation/animation/enemy_sprite_resolver.dart';
import '../presentation/animation/player_sprite_resolver.dart';

/// ユーザーからの入力を受け付け、GameModelに伝える
/// GameModelの内容をレンダリングする
class GameWidget extends Game with TapDetector {

  bool _initialized = false;
  World _world;

  GameWidget() {
    _initialize();
  }

  _initialize() async {
    await Flame.util.setLandscape();
    await Flame.util.fullScreen();
    await Flame.util.initialDimensions();
    // Size dimension = await Flame.util.initialDimensions();

    _world = World();
    _world.addEntity(Player(PlayerSpriteResolver(),  x: 10, y: 200));
    _world.addEntity(Enemy(EnemySpriteResolver(), x: 200, y: 200));
    
    _world.createJoystick(60, 280);
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

    _world.entities.forEach((entity) {
      entity.getSprites().forEach((sprite) {
        sprite.render(canvas);
      });
    });
  }

  void onPointerMove(PointerMoveEvent event) {
    final pointerEvent = UiPointerEvent(PointerEventType.UPDATE, event.position.dx, event.delta.dy);
    _world.onPointerEvent(pointerEvent);
  }

  void onPointerDown(PointerDownEvent event) {
    final pointerEvent = UiPointerEvent(PointerEventType.START, event.position.dx, event.position.dy);
    _world.onPointerEvent(pointerEvent);
  }

  void onPointerUp(PointerUpEvent event) {
    final pointerEvent = UiPointerEvent(PointerEventType.END, event.position.dx, event.position.dy);
    _world.onPointerEvent(pointerEvent);
  }

}
