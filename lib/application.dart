import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/widgets.dart';

import 'domain/entity/player.dart';
import 'domain/world.dart';

/// ユーザーからの入力を受け付け、GameModelに伝える
/// GameModelの内容をレンダリングする
class Application extends Game with HorizontalDragDetector, TapDetector {

  World _world;

  Application() {
    _initialize();
  }

  _initialize() async {
    await Flame.util.setLandscape();
    await Flame.util.fullScreen();
    // Size dimension = await Flame.util.initialDimensions();

    _world = World();
    _world.addEntity(new Player());
  }

  @override
  void update(double dt) {
    // TODO: implement update
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement update
  }
  
}
