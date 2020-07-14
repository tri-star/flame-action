import 'package:flame_action/domain/behaviours/sling_shot/sling_shot_behaviour.dart';
import 'package:flame_action/engine/image/sprite_string/pop_with_gravity_string.dart';
import 'package:flame_action/engine/image/sprite_string/sprite_letter.dart';
import 'package:flame_action/entity/generic_bullet.dart';
import 'package:flame_action/presentation/image/action_button_sprite_resolver.dart';
import 'package:flame_action/presentation/image/enemy_sprite_resolver.dart';
import 'package:flame_action/presentation/image/joystick_sprite_resolver.dart';
import 'package:flame_action/presentation/image/particle_sprite_resolver.dart';
import 'package:flame_action/presentation/renderer/status_card_renderer.dart';

import '../engine/entity/entity.dart';
import '../engine/entity/base_entity_factory.dart';
import '../engine/entity/joystick.dart';
import '../presentation/image/basic_obstacle_sprite_resolver.dart';
import '../presentation/image/player_sprite_resolver.dart';
import 'basic_obstacle.dart';
import 'action_button.dart';
import 'enemy.dart';
import 'ground.dart';
import 'particle/general_particle.dart';
import 'player.dart';
import 'ui/status_card.dart';
import 'ui/status_card_organizer.dart';

class EntityFactory extends BaseEntityFactory {
  @override
  Entity create(String key, double x, double y, double z,
      {Map<String, dynamic> options}) {
    int newId = getNextId();
    switch (key) {
      case 'player':
        return Player(newId, PlayerSpriteResolver(), x: x, y: y, z: z);
      case 'enemy01':
        return Enemy(newId, key, EnemySpriteResolver(),
            SlingShotBehaviourBuilder(), 4000,
            x: x, y: y, z: z);
      case 'status_card':
        return StatusCard(newId, options['target'], StatusCardRenderer(),
            x: x, y: y);
      case 'status_card_organizer':
        return StatusCardOrganizer(newId);
      case 'ash_tray':
        return BasicObstacle(newId, key, BasicObstacleSpriteResolver(key),
            x: x, y: y, z: z);
      case 'dust_box01':
        return BasicObstacle(newId, key, BasicObstacleSpriteResolver(key),
            x: x, y: y, z: z);
      case 'fire_distinguisher_01':
        return BasicObstacle(newId, key, BasicObstacleSpriteResolver(key),
            x: x, y: y, z: z);
      case 'sling_ball':
        return GenericBullet(newId, key, BasicObstacleSpriteResolver(key),
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
        return ActionButton(newId, key, ActionButtonSpriteResolver(),
            x: x, y: y);
      case 'pop_with_gravity_string':
        return PopWithGravityString(newId, key, options['message'], x, y, z);
      case 'sprite_letter':
        return SpriteLetter(newId, key, options['letter'], x, y, z,
            fontName: options['font_name'],
            gravityFlag: options['gravity_flag'],
            collidableFlag: options['collidable_flag'],
            bounceFactor: options['bounce_factor']);
      case 'particle_damage01':
        return GeneralParticle(newId, key, ParticleSpriteResolver(key),
            x: x, y: y, z: z);
    }
    throw new ArgumentError.value(key);
  }
}
