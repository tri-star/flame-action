import 'package:flame_action/engine/image/sprite_font.dart';
import 'package:flutter/widgets.dart';

import 'engine/entity/entity.dart';
import 'engine/presentation/flame/flame_sprite_font.dart';
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
  Entity enemy = entityFactory.create('enemy01', 600, worldH, 50);
  gameWidget.setBackground('background01.png');
  gameWidget.addEntity(player);
  gameWidget.addEntity(enemy);
  gameWidget.addEntity(entityFactory.create('ash_tray', 400, worldH, 50));
  gameWidget.addEntity(entityFactory.create('dust_box01', 850, worldH, 60));
  gameWidget.addEntity(
      entityFactory.create('fire_distinguisher_01', 1050, worldH, 80));
  gameWidget.addEntity(entityFactory.create('ground', 0, worldH, 0,
      options: {'w': worldW, 'h': worldH, 'd': worldD}));
  gameWidget.addHud(entityFactory.create('joystick', 90, 320, 0));
  gameWidget.addHud(entityFactory.create(
      'action_button', gameWidget.getDeviceWidth() - 90, 320, 0));
  gameWidget.addHud(entityFactory
      .create('status_card', 10, 10, 0, options: {'target': player}));
  gameWidget.addHud(entityFactory
      .create('status_card', 10, 10, 0, options: {'target': player}));
  gameWidget.addHud(entityFactory
      .create('status_card', 130, 10, 0, options: {'target': enemy}));

  gameWidget.setCameraFocus(player);

  runApp(gameWidget.getWidget());
}
