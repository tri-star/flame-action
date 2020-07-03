import 'package:flame_action/engine/image/sprite_font.dart';
import 'package:flame_action/presentation/flame/flame_sprite_font.dart';
import 'package:flutter/widgets.dart';

import 'domain/entity/entity.dart';
import 'domain/entity/entity_factory.dart';
import 'engine/game_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GameWidget gameWidget = GameWidget();
  EntityFactory entityFactory = EntityFactory();

  double worldW = 2000;
  double worldH = 200;
  double worldD = 100;
  await gameWidget.initialize(worldW, worldH, worldD, entityFactory);

  SpriteFontRegistry().register(
      'default',
      FlameSpriteFont('damage_number.png', 10, 20, 5, 1,
          type: SpriteFontType.NUMBER));

  Entity player = entityFactory.create('player', 10, worldH, 40);
  gameWidget.setBackground('background01.png');
  gameWidget.addEntity(player);
  gameWidget.addEntity(entityFactory.create('enemy01', 600, worldH, 50));
  gameWidget.addEntity(entityFactory.create('ash_tray', 400, worldH, 50));
  gameWidget.addEntity(entityFactory.create('dust_box01', 450, worldH, 60));
  gameWidget.addEntity(entityFactory.create('ground', 0, worldH, 0,
      options: {'w': worldW, 'h': worldH, 'd': worldD}));

  gameWidget.createJoystick(90, 320);
  gameWidget.setCameraFocus(player);

  runApp(gameWidget.getWidget());
}
