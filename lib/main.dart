
import 'package:flutter/widgets.dart';

import 'domain/entity/enemy.dart';
import 'domain/entity/ground.dart';
import 'domain/entity/player.dart';
import 'engine/game_widget.dart';
import 'presentation/image/enemy_sprite_resolver.dart';
import 'presentation/image/player_sprite_resolver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GameWidget gameWidget = GameWidget();

  double worldW = 2000;
  double worldH = 200;
  double worldD = 100;
  await gameWidget.initialize(worldW, worldH, worldD);

  Player player = Player(1, PlayerSpriteResolver(),  x: 10, y: worldH, z: 40);
  gameWidget.setBackground('background01.png');
  gameWidget.addEntity(player);
  gameWidget.addEntity(Enemy(2, EnemySpriteResolver(), x: 600, y: worldH, z: 50));
  gameWidget.addEntity(Ground(10, x: 0, y: worldH, z: 0, w: worldW, h: worldH, d: worldD));
  
  gameWidget.createJoystick(90, 320);
  gameWidget.setCameraFocus(player);

  runApp(gameWidget.getWidget());
}
