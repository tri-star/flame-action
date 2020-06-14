import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame_action/domain/entity/joystick.dart';
import 'package:flame_action/presentation/animation/enemy_sprite_resolver.dart';
import 'package:flame_action/presentation/animation/player_sprite_resolver.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'domain/entity/enemy.dart';
import 'domain/entity/player.dart';
import 'engine/joystick.dart';
import 'engine/world.dart';
import 'presentation/animation/joystick_sprite_resolver.dart';

/// ユーザーからの入力を受け付け、GameModelに伝える
/// GameModelの内容をレンダリングする
class Application extends Game with TapDetector {

  bool _initialized = false;
  World _world;
  JoystickEventHandler _joystickEventHandler;

  Application() {
    _initialize();
  }

  _initialize() async {
    await Flame.util.setLandscape();
    await Flame.util.fullScreen();
    // Size dimension = await Flame.util.initialDimensions();
    _joystickEventHandler = JoystickEventHandler(Rect.fromLTWH(60-40.0, 280-40.0, 80, 80));

    _world = World();
    _world.addEntity(Player(PlayerSpriteResolver(),  x: 10, y: 200));
    _world.addEntity(Enemy(EnemySpriteResolver(), x: 200, y: 200));
    _world.addEntity(JoyStick(JoyStickSpriteResolver(), x: 60, y: 280));
    _world.addJoystickEventHandler(_joystickEventHandler);
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
    final joystickEvent = JoystickInputEvent(JoystickInputEventType.UPDATE, event.position.dx, event.delta.dy);
    _joystickEventHandler.handle(joystickEvent);
  }

  void onPointerDown(PointerDownEvent event) {
    final joystickEvent = JoystickInputEvent(JoystickInputEventType.START, event.position.dx, event.position.dy);
    _joystickEventHandler.handle(joystickEvent);
  }

  void onPointerUp(PointerUpEvent event) {
    final joystickEvent = JoystickInputEvent(JoystickInputEventType.END, event.position.dx, event.position.dy);
    _joystickEventHandler.handle(joystickEvent);
  }

}
