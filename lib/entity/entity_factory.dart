import '../domain/behaviours/jimmy/jimmy_behaviour.dart';
import '../domain/behaviours/sling_shot/sling_shot_behaviour.dart';
import '../engine/entity/entity.dart';
import '../engine/entity/base_entity_factory.dart';
import '../engine/entity/joystick.dart';
import '../engine/image/sprite_string/pop_with_gravity_string.dart';
import '../engine/image/sprite_string/sprite_letter.dart';
import '../presentation/image/basic_obstacle_sprite_resolver.dart';
import '../presentation/image/action_button_sprite_resolver.dart';
import '../presentation/image/enemy02_sprite_resolver.dart';
import '../presentation/image/enemy_sprite_resolver.dart';
import '../presentation/image/joystick_sprite_resolver.dart';
import '../presentation/image/particle_sprite_resolver.dart';
import '../presentation/image/player_sprite_resolver.dart';
import '../presentation/image/start_button_sprite_resolver.dart';
import '../presentation/image/title_sprite_resolver.dart';
import '../presentation/renderer/status_card_renderer.dart';

import 'particle/general_particle.dart';
import 'ui/start_button.dart';
import 'ui/status_card.dart';
import 'ui/status_card_organizer.dart';
import 'generic_bullet.dart';
import 'basic_obstacle.dart';
import 'action_button.dart';
import 'enemy.dart';
import 'enemy2.dart';
import 'ground.dart';
import 'player.dart';

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
      case 'enemy02':
        return Enemy2(
            newId, key, Enemy02SpriteResolver(), JimmyBehaviourBuilder(), 4000,
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
      case 'start_button':
        return StartButton(newId, key, StartButtonSpriteResolver(), x: x, y: y);
      case 'title':
        return BasicObstacle(newId, key, TitleSpriteResolver(),
            x: x, y: y, z: z);
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
