import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/widgets.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'domain/entity/entity.dart';
import 'domain/entity/player.dart';
import 'domain/world.dart';

/// ユーザーからの入力を受け付け、GameModelに伝える
/// GameModelの内容をレンダリングする
class Application extends Game with HorizontalDragDetector, TapDetector {

  bool _initialized = false;
  World _world;

  // TODO: 後で適切な場所に移動
  SpriteSheet _spriteSheet;
  FlameAnimation.Animation _animation;

  Application() {
    _initialize();
  }

  _initialize() async {
    await Flame.util.setLandscape();
    await Flame.util.fullScreen();
    // Size dimension = await Flame.util.initialDimensions();

    _world = World();
    _world.addEntity(Player());
    _spriteSheet = SpriteSheet(imageName: 'enemy01_state_normal.png', textureWidth: 80, textureHeight: 100, columns: 2, rows: 1);
    _animation = _spriteSheet.createAnimation(0, stepTime: 0.2);
    _initialized = true;
  }

  @override
  void update(double dt) {
    if(!_initialized) {
      return;
    }
    _world.entity.update(dt);
    _animation.update(dt);
  }

  @override
  void render(Canvas canvas) {
    if(!_initialized) {
      return;
    }

    Entity entity = _world.entity;
    _animation.getSprite().renderPosition(canvas, Position(entity.x, entity.y));
  }
  
}
