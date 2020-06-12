import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame_action/presentation/animation/enemy_sprite_resolver.dart';
import 'package:flame_action/presentation/animation/player_sprite_resolver.dart';
import 'package:flutter/widgets.dart';
import 'domain/entity/enemy.dart';
import 'domain/entity/player.dart';
import 'domain/world.dart';

/// ユーザーからの入力を受け付け、GameModelに伝える
/// GameModelの内容をレンダリングする
class Application extends Game with HorizontalDragDetector, TapDetector {

  bool _initialized = false;
  World _world;

  Application() {
    _initialize();
  }

  _initialize() async {
    await Flame.util.setLandscape();
    await Flame.util.fullScreen();
    // Size dimension = await Flame.util.initialDimensions();

    _world = World();
    _world.addEntity(Player(PlayerSpriteResolver(),  x: 10, y: 200));
    _world.addEntity(Enemy(EnemySpriteResolver(), x: 200, y: 200));
    _initialized = true;
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
  
}
