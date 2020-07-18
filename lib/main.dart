import 'package:flame_action/engine/image/sprite_font.dart';
import 'package:flutter/widgets.dart';

import 'engine/entity/entity.dart';
import 'engine/presentation/flame/flame_sprite_font.dart';
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

  SpriteFontRegistry().register(
      'default',
      FlameSpriteFont('damage_number.png', 10, 20, 10, 1,
          type: SpriteFontType.NUMBER));

  Entity player = entityFactory.create('player', 10, worldH, 40);
  Entity enemy = entityFactory.create('enemy01', 600, worldH, 50);
  Entity enemy2 = entityFactory.create('enemy01', 700, worldH, 10);
  gameWidget.setBackground('background01.png', 2000, 300);
  gameWidget.addUnit(player);
  gameWidget.addUnit(enemy);
  gameWidget.addUnit(enemy2);
  gameWidget.addEntity(entityFactory.create('ash_tray', 400, worldH, 50));
  gameWidget.addEntity(entityFactory.create('dust_box01', 850, worldH, 20));
  gameWidget.addEntity(
      entityFactory.create('fire_distinguisher_01', 1050, worldH, 80));
  gameWidget.addEntity(entityFactory.create('ground', 0, worldH, 0,
      options: {'w': worldW, 'h': worldH, 'd': worldD}));
  gameWidget.addHud(entityFactory.create('joystick', 90, gameH - 90, 0));
  gameWidget
      .addHud(entityFactory.create('action_button', gameW - 90, gameH - 90, 0));
  gameWidget.addHud(entityFactory.create('status_card_organizer', 0, 0, 0));

  gameWidget.setCameraFocus(player);

  runApp(gameWidget.getWidget());
}
