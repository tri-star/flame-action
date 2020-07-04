import 'package:flame_action/engine/image/sprite_string/pop_with_gravity_string.dart';
import 'package:flame_action/engine/image/sprite_string/sprite_letter.dart';
import 'package:flame_action/presentation/image/action_button_sprite_resolver.dart';
import 'package:flame_action/presentation/image/enemy_sprite_resolver.dart';
import 'package:flame_action/presentation/image/joystick_sprite_resolver.dart';

import '../../domain/entity/basic_obstacle.dart';
import '../../domain/entity/entity.dart';
import '../../domain/entity/player.dart';
import '../../engine/entity/base_entity_factory.dart';
import '../../presentation/image/basic_obstacle_sprite_resolver.dart';
import '../../presentation/image/player_sprite_resolver.dart';
import 'action_button.dart';
import 'enemy.dart';
import 'ground.dart';
import 'joystick.dart';

class EntityFactory extends BaseEntityFactory {
  @override
  Entity create(String key, double x, double y, double z,
      {Map<String, dynamic> options}) {
    int newId = getNextId();
    switch (key) {
      case 'player':
        return Player(newId, PlayerSpriteResolver(), x: x, y: y, z: z);
      case 'enemy01':
        return Enemy(newId, EnemySpriteResolver(), x: x, y: y, z: z);
      case 'ash_tray':
        return BasicObstacle(
            newId, 'ash_tray', BasicObstacleSpriteResolver('ash_tray'),
            x: x, y: y, z: z);
      case 'dust_box01':
        return BasicObstacle(
            newId, 'dust_box01', BasicObstacleSpriteResolver('dust_box01'),
            x: x, y: y, z: z);
      case 'ground':
        return Ground(newId,
            x: x,
            y: y,
            z: z,
            w: options['w'],
            h: options['h'],
            d: options['d']);

      case 'joystick':
        return JoyStick(newId, JoyStickSpriteResolver(), x: x, y: y);
      case 'action_button':
        return ActionButton(newId, ActionButtonSpriteResolver(), x: x, y: y);
      case 'pop_with_gravity_string':
        return PopWithGravityString(newId, options['message'], x, y, z);
      case 'sprite_letter':
        return SpriteLetter(newId, options['letter'], x, y, z,
            fontName: options['font_name'],
            gravityFlag: options['gravity_flag'],
            collidableFlag: options['collidable_flag'],
            bounceFactor: options['bounce_factor']);
    }
    throw new ArgumentError.value(key);
  }
}
