import 'package:flame_action/domain/entity/entity.dart';
import 'package:flame_action/engine/entity/base_entity_factory.dart';
import 'package:flame_action/engine/services/collision_detect_service.dart';

import 'camera.dart';
import 'coordinates.dart';
import 'image/sprite.dart';
import 'input_event.dart';
import 'services/boundary_adjustment_service.dart';
import '../util/list.dart';
import 'services/input_event_service.dart';

class WorldContext {
  ZOrderedCollection entities;
  CollisionDetectService collisionDetectService;
  InputEventService inputEventService;
  List<Entity> _pendingEntities;
  BaseEntityFactory entityFactory;

  WorldContext(this.collisionDetectService, this.entities, this.entityFactory,
      this.inputEventService)
      : _pendingEntities = List<Entity>();

  void addEntity(Entity entity) {
    _pendingEntities.add(entity);
  }

  List<Entity> getPendingEntities() {
    return _pendingEntities;
  }

  void clearPendingEntities() {
    _pendingEntities.clear();
  }
}

/// ゲームの本体。
/// ユーザーの入力などをデバイスに依存しない形で受け付ける
/// World単位でスローモーションにしたり高速化するなど
/// 時間軸を変更することが可能で、Worldはゲーム内に複数存在する可能性がある
class World {
  Sprite background;
  ZOrderedCollection _entities;
  List<Entity> _huds;
  BoundaryAdjustmentService _boundaryAdjustmentService;
  CollisionDetectService _collisionDetectService;
  InputEventService _inputEventService;
  WorldContext _context;
  Rect3d _worldRect;
  Camera _camera;

  int _randomSeed;

  World(double worldW, double worldH, double worldD, double cameraW,
      double cameraH, BaseEntityFactory entityFactory,
      {randomSeed: 0})
      : _randomSeed = randomSeed,
        _entities = ZOrderedCollection(),
        _huds = List<Entity>(),
        _camera = Camera(cameraW, cameraH, worldW, worldH + worldD),
        _worldRect = Rect3d.fromSizeAndPosition(
            Size3d(worldW, worldH, worldD), Position3d(0, 0, 0)),
        _boundaryAdjustmentService = BoundaryAdjustmentService() {
    _collisionDetectService = CollisionDetectService(_entities);
    _inputEventService = InputEventService(_entities, _huds);
    _context = WorldContext(
        _collisionDetectService, _entities, entityFactory, _inputEventService);
  }

  void update(double dt) {
    //TODO: firstで判定しなくても動作するようにする
    if (_entities.first == null) {
      _context.getPendingEntities().forEach((entity) {
        _entities.add(entity);
      });
      _context.clearPendingEntities();
      return;
    }
    _entities.forEach((entity) {
      entity.update(dt, _context);
      _boundaryAdjustmentService.adjust(_worldRect, entity);
    });
    _huds.forEach((entity) {
      entity.update(dt, _context);
    });
    _camera.update();
    _context.getPendingEntities().forEach((entity) {
      _entities.add(entity);
    });
    _context.clearPendingEntities();
    _entities.sync();
  }

  void addEntity(Entity entity) {
    _context.addEntity(entity);
  }

  void addHud(Entity entity) {
    _huds.add(entity);
  }

  void setBackground(Sprite _sprite) {
    background = _sprite;
  }

  /// 画面からのポインタに関するイベントを受け取る
  void onPointerEvent(UiPointerEvent uiPointerEvent) {
    //_pointerEventHandler.handle(uiPointerEvent);
    _huds.forEach((entity) {
      if (entity is PointerEventListener) {
        (entity as PointerEventListener)
            .onPointerEvent(_context, uiPointerEvent);
      }
    });
    _entities.forEach((entity) {
      if (entity is PointerEventListener) {
        (entity as PointerEventListener)
            .onPointerEvent(_context, uiPointerEvent);
      }
    });
  }

  ZOrderedCollection get entities {
    return _entities;
  }

  List<Entity> get huds => _huds;
  Camera get camera => _camera;
}
