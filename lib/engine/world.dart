import 'dart:ui';

import 'package:flame_action/engine/entity/entity.dart';
import 'package:flame_action/engine/entity/base_entity_factory.dart';
import 'package:flame_action/engine/services/collision_detect_service.dart';

import 'camera.dart';
import 'coordinates.dart';
import 'image/sprite.dart';
import 'input_event.dart';
import 'services/boundary_adjustment_service.dart';
import '../util/list.dart';
import '../util/ticker.dart';
import 'services/input_event_service.dart';

class WorldContext {
  ZOrderedCollection entities;
  ZOrderedCollection huds;
  CollisionDetectService collisionDetectService;
  InputEventService inputEventService;
  List<Entity> _pendingEntities;
  List<Entity> _pendingHuds;
  BaseEntityFactory entityFactory;

  WorldContext(this.collisionDetectService, this.entities, this.huds,
      this.entityFactory, this.inputEventService)
      : _pendingEntities = List<Entity>(),
        _pendingHuds = List<Entity>();

  void addEntity(Entity entity) {
    _pendingEntities.add(entity);
  }

  void addUnit(Entity entity) {
    _pendingEntities.add(entity);
    _pendingHuds.add(entityFactory
        .create('status_card', 0, 0, 0, options: {'target': entity}));
  }

  List<Entity> getPendingEntities() {
    return _pendingEntities;
  }

  List<Entity> getPendingHuds() {
    return _pendingHuds;
  }

  void clearPendingEntities() {
    _pendingEntities.clear();
  }

  void clearPendingHuds() {
    _pendingHuds.clear();
  }
}

/// ゲームの本体。
/// ユーザーの入力などをデバイスに依存しない形で受け付ける
/// World単位でスローモーションにしたり高速化するなど
/// 時間軸を変更することが可能で、Worldはゲーム内に複数存在する可能性がある
class World {
  Sprite background;
  ZOrderedCollection _entities;
  ZOrderedCollection _huds;
  BoundaryAdjustmentService _boundaryAdjustmentService;
  CollisionDetectService _collisionDetectService;
  InputEventService _inputEventService;
  WorldContext _context;
  Rect3d _worldRect;
  Camera _camera;
  Ticker _ticker;

  int _randomSeed;

  World(double worldW, double worldH, double worldD, double cameraW,
      double cameraH, BaseEntityFactory entityFactory,
      {randomSeed: 0})
      : _randomSeed = randomSeed,
        _entities = ZOrderedCollection(),
        _huds = ZOrderedCollection(),
        _camera = Camera(cameraW, cameraH, worldW, worldH + worldD),
        _ticker = Ticker(),
        _worldRect = Rect3d.fromSizeAndPosition(
            Size3d(worldW, worldH, worldD), Position3d(0, 0, 0)),
        _boundaryAdjustmentService = BoundaryAdjustmentService() {
    _collisionDetectService = CollisionDetectService(_entities);
    _inputEventService = InputEventService(_entities, _huds);
    _context = WorldContext(_collisionDetectService, _entities, _huds,
        entityFactory, _inputEventService);
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

    _ticker.tick(dt, () {
      _entities.forEach((entity) {
        entity.update(_context);
        _boundaryAdjustmentService.adjust(_worldRect, entity);
      });
      _huds.forEach((entity) {
        entity.update(_context);
      });
      _camera.update();
      _context.getPendingEntities().forEach((entity) {
        _entities.add(entity);
      });
      _context.getPendingHuds().forEach((entity) {
        _huds.add(entity);
      });
      _context.clearPendingEntities();
      _context.clearPendingHuds();
      _entities.sync();
      _huds.sync();
    });
  }

  void addEntity(Entity entity) {
    _context.addEntity(entity);
  }

  void addHud(Entity entity) {
    _huds.add(entity);
  }

  void addUnit(Entity entity) {
    _context.addUnit(entity);
  }

  void setBackground(Sprite _sprite) {
    background = _sprite;
  }

  /// 画面からのポインタに関するイベントを受け取る
  void onPointerEvent(UiPointerEvent uiPointerEvent) {
    //_pointerEventHandler.handle(uiPointerEvent);
    Offset point = Offset(uiPointerEvent.x, uiPointerEvent.y);
    bool capturedEvent;

    _huds.forEach((entity) {
      capturedEvent = entity is CapturePointerEvent &&
              (entity as CapturePointerEvent)
                  ?.isCapturedPointer(uiPointerEvent) ??
          false;
      if (capturedEvent || entity.getRenderRect().contains(point)) {
        if (entity is PointerEventListener) {
          (entity as PointerEventListener)
              .onPointerEvent(_context, uiPointerEvent);
        }
      }
    });
    _entities.forEach((entity) {
      capturedEvent = entity is CapturePointerEvent &&
              (entity as CapturePointerEvent)
                  ?.isCapturedPointer(uiPointerEvent) ??
          false;
      if (capturedEvent || entity.getRenderRect().contains(point)) {
        if (entity is PointerEventListener) {
          (entity as PointerEventListener)
              .onPointerEvent(_context, uiPointerEvent);
        }
      }
    });
  }

  ZOrderedCollection get entities {
    return _entities;
  }

  ZOrderedCollection get huds => _huds;
  Camera get camera => _camera;
}
