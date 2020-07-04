import 'package:flame_action/domain/entity/entity_factory.dart';
import 'package:flame_action/engine/entity/base_entity_factory.dart';
import 'package:flame_action/engine/services/collision_detect_service.dart';
import 'package:flame_action/engine/services/input_event_service.dart';
import 'package:flame_action/engine/world.dart';
import 'package:flame_action/util/list.dart';

class WorldContextUtil {
  static WorldContext create(
      {CollisionDetectService collisionDetectService,
      ZOrderedCollection entities,
      BaseEntityFactory entityFactory,
      InputEventService inputEventService}) {
    if (entities == null) {
      entities = ZOrderedCollection();
    }
    if (collisionDetectService == null) {
      collisionDetectService = new CollisionDetectService(entities);
    }
    if (inputEventService == null) {
      inputEventService = new InputEventService(entities);
    }
    if (entityFactory == null) {
      entityFactory = EntityFactory();
    }
    return WorldContext(
        collisionDetectService, entities, entityFactory, inputEventService);
  }
}
