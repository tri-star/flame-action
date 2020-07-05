import 'package:flame_action/engine/entity/entity.dart';
import 'package:flame_action/domain/entity/player.dart';
import 'package:flame_action/engine/input_event.dart';
import 'package:flame_action/engine/services/input_event_service.dart';
import 'package:flame_action/engine/world.dart';
import 'package:flame_action/engine/presentation/stub/stub_sprite_resolver.dart';
import 'package:flame_action/util/list.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../util/world_context.dart';

void main() {
  group('InputEventService', () {
    ZOrderedCollection entities;
    InputEventService service;
    WorldContext context;

    setUp(() {
      entities = ZOrderedCollection();
      service = InputEventService(entities, ZOrderedCollection());
      context = WorldContextUtil.create(entities: entities);
    });

    group('notifyMoveEvent', () {
      test('イベントが通知されること', () {
        Entity entity = Player(0, StubSpriteResolver(w: 60, h: 100, d: 20),
            x: 0, y: 0, z: 0);
        entity.disableGravity();
        entities.add(entity);

        InputMoveEvent event = InputMoveEvent(distanceX: 10, distanceY: -10);
        service.notifyMoveEvent(event);
        entity.update(0.016, context);

        expect(entity.getX(), 2, reason: 'PlayerのX軸方向の移動量(=2)に応じた距離を移動していません');
        expect(entity.getZ(), -1, reason: 'PlayerのZ軸方向の移動量(=1)に応じた距離を移動していません');
      });
    });
  });
}
