import 'package:flame_action/engine/random/native_random_generator.dart';
import 'package:flame_action/engine/random/random_generator.dart';
import 'package:flame_action/entity/entity_factory.dart';
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
      InputEventService inputEventService,
      RandomGenerator randomGenerator}) {
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
    if (randomGenerator == null) {
      randomGenerator = NativeRandomGenerator(null);
    }
    return WorldContext(collisionDetectService, entities, entityFactory,
        inputEventService, randomGenerator);
  }
}
