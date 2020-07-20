import 'package:flame_action/engine/presentation/wipe/fading_wipe.dart';
import 'package:flame_action/scene/title_scene.dart';
import 'package:flutter/widgets.dart';

import 'entity/entity_factory.dart';
import 'engine/game_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GameWidget gameWidget = GameWidget();
  EntityFactory entityFactory = EntityFactory();

  double worldW = 2000;
  double worldH = 200;
  double worldD = 100;
  double gameW = 640;
  double gameH = 360;
  await gameWidget.initialize(
      gameW, gameH, worldW, worldH, worldD, entityFactory);

  TitleScene titleScene = TitleScene(FadeInWipe(3.0), FadeOutWipe(1.5));
  gameWidget.setScene(titleScene);

  runApp(gameWidget.getWidget());
}
