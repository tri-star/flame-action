
import 'package:flame_action/domain/entity/entity.dart';

import 'joystick.dart';

/// ゲームの本体。
/// ユーザーの入力などをデバイスに依存しない形で受け付ける
/// World単位でスローモーションにしたり高速化するなど
/// 時間軸を変更することが可能で、Worldはゲーム内に複数存在する可能性がある
class World implements JoystickListener {

  Entity _entity;
  List<Entity> _entities;
  PointerEventHandler _joystickEventHandler;

  int _randomSeed;  

  World({randomSeed: 0}): 
    _randomSeed = randomSeed,
    _entities = List<Entity>();

  void update(double dt) {
    _entities.forEach((entity) {
      entity.update(dt);
    });
  }

  void addEntity(Entity entity) {
    _entity = entity;
    _entities.add(entity);
  }

  void addJoystickEventHandler(PointerEventHandler handler) {
    _joystickEventHandler = handler;
    handler.addListener('world', this);
  }

  @override
  onJoystickMove(JoystickMoveEvent event) {
    _entities.forEach((entity) {
      if(entity is JoystickListener) {
        (entity as JoystickListener).onJoystickMove(event);
      }
    });
  }

  Entity get entity => _entity;
  List<Entity> get entities => _entities;
}
