import 'package:flame_action/engine/entity/entity.dart';
import 'package:flame_action/engine/presentation/flame/flame_sprite_font.dart';
import 'package:flame_action/engine/presentation/wipe/fading_wipe.dart';
import 'package:flame_action/engine/scene/stage_scene.dart';
import 'package:flame_action/engine/stage/stage.dart';
import 'package:flame_action/entity/entity_factory.dart';

import '../engine/image/sprite_font.dart';

import '../engine/camera.dart';
import '../engine/world.dart';

class FightScene extends StageScene {
  Stage _stage;

  FightScene(Stage stage)
      : _stage = stage,
        super(stage,
            enteringWipe: FadeInWipe(1.5), leavingWipe: FadeOutWipe(2.0));

  @override
  Future<void> onInitialize(WorldContext context, Camera camera) async {
    SpriteFontRegistry().register(
        'default',
        FlameSpriteFont('damage_number.png', 10, 20, 10, 1,
            type: SpriteFontType.NUMBER));

    EntityFactory entityFactory = context.entityFactory;
    double worldW = 2000; //contextなどから取得するか、ここで設定することにしてGameWidgetでは使わないことにする
    double worldH = 200;
    double worldD = 100;
    double gameW = camera.w;
    double gameH = camera.h;

    Entity player = entityFactory.create('player', 10, worldH, 40);
    context.setBackground('background01.png', 2000, 300);
    context.addUnit(player);
    context.addEntity(entityFactory.create('ash_tray', 400, worldH, 50));
    context.addEntity(entityFactory.create('dust_box01', 850, worldH, 20));
    context.addEntity(
        entityFactory.create('fire_distinguisher_01', 1050, worldH, 80));
    context.addEntity(entityFactory.create('ground', 0, worldH, 0,
        options: {'w': worldW, 'h': worldH, 'd': worldD}));
    context.addHud(entityFactory.create('joystick', 90, gameH - 90, 0));
    context.addHud(
        entityFactory.create('action_button', gameW - 90, gameH - 90, 0));
    context.addHud(entityFactory.create('status_card_organizer', 0, 0, 0));

    camera.followEntity(player);
  }
}
