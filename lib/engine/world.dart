import 'dart:ui';

import 'package:flame/sprite.dart' as Flame;

import '../util/list.dart';
import '../util/ticker.dart';
import 'camera.dart';
import 'coordinates.dart';
import 'entity/entity.dart';
import 'entity/base_entity_factory.dart';
import 'image/sprite.dart';
import 'input_event.dart';
import 'presentation/flame/flame_sprite.dart';
import 'random/native_random_generator.dart';
import 'random/random_generator.dart';
import 'screen.dart';
import 'services/boundary_adjustment_service.dart';
import 'services/collision_detect_service.dart';
import 'services/input_event_service.dart';

class WorldContext {
  Sprite _background;
  ZOrderedCollection entities;
  CollisionDetectService collisionDetectService;
  InputEventService inputEventService;
  List<Entity> _pendingEntities;
  Map<String, Entity> _taggedEntities;
  BaseEntityFactory entityFactory;
  RandomGenerator randomGenerator;
  bool _canControl;

  WorldContext(this.collisionDetectService, this.entities, this.entityFactory,
      this.inputEventService, this.randomGenerator)
      : _pendingEntities = List<Entity>(),
        _taggedEntities = Map<String, Entity>(),
        _canControl = true;

  void addEntity(Entity entity) {
    _pendingEntities.add(entity);
  }

  void addHud(Entity entity) {
    entity.setLayer('hud');
    _pendingEntities.add(entity);
  }

  void addUnit(Entity entity) {
    _pendingEntities.add(entity);
    _pendingEntities.add(entityFactory
        .create('status_card', 0, 0, 0, options: {'target': entity}));
  }

  void setBackground(String fileName, double w, double h) {
    _background = FlameSprite(Flame.Sprite(fileName),
        x: 0, y: 0, z: 0, w: w, h: h, d: 1); // Flameを直接使わないようにする
  }

  Sprite getBackground() => _background;

  Entity findTaggedFirst(String tag, {bool useCache = false}) {
    if (useCache && _taggedEntities.containsKey(tag)) {
      return _taggedEntities[tag];
    }
    _taggedEntities[tag] = null;
    entities.forEach((entity) {
      if (entity.getTags().contains(tag)) {
        _taggedEntities[tag] = entity;
        return;
      }
    });
    if (_taggedEntities[tag] == null) {
      _taggedEntities.remove(tag);
      return null;
    }
    return _taggedEntities[tag];
  }

  List<Entity> getPendingEntities() {
    return _pendingEntities;
  }

  void clearPendingEntities() {
    _pendingEntities.clear();
  }

  bool canControl() => _canControl;

  void disableControl() {
    _canControl = false;
  }

  void enableControl() {
    _canControl = true;
  }
}

/// ゲームの本体。
/// ユーザーの入力などをデバイスに依存しない形で受け付ける
/// World単位でスローモーションにしたり高速化するなど
/// 時間軸を変更することが可能で、Worldはゲーム内に複数存在する可能性がある
class World {
  ZOrderedCollection _entities;
  BoundaryAdjustmentService _boundaryAdjustmentService;
  CollisionDetectService _collisionDetectService;
  InputEventService _inputEventService;
  WorldContext _context;
  Rect3d _worldRect;
  ScreenAdjustment _screenAdjustment;
  Camera _camera;
  Ticker _ticker;
  RandomGenerator _randomGenerator;

  int _randomSeed;

  World(double worldW, double worldH, double worldD,
      ScreenAdjustment screenAdjustment, BaseEntityFactory entityFactory,
      {randomSeed})
      : _entities = ZOrderedCollection(),
        _ticker = Ticker(),
        _worldRect = Rect3d.fromSizeAndPosition(
            Size3d(worldW, worldH, worldD), Position3d(0, 0, 0)),
        _boundaryAdjustmentService = BoundaryAdjustmentService() {
    _screenAdjustment = screenAdjustment;
    _camera = Camera(_screenAdjustment, worldW, worldH + worldD);
    _randomSeed = randomSeed ?? DateTime.now().microsecondsSinceEpoch;
    _randomGenerator = NativeRandomGenerator(_randomSeed);
    _collisionDetectService = CollisionDetectService(_entities);
    _inputEventService = InputEventService(_entities);
    _context = WorldContext(_collisionDetectService, _entities, entityFactory,
        _inputEventService, _randomGenerator);
  }

  void update(double dt) {
    _ticker.tick(dt, () {
      _entities.whereLayer('default').forEach((entity) {
        //TODO: 0件の場合にnullが返ってくることを直す
        if (entity == null) {
          return;
        }
        entity.update(_context);
        _boundaryAdjustmentService.adjust(_worldRect, entity);
      });
      _entities.whereLayer('hud').forEach((entity) {
        entity?.update(_context);
      });
      _camera.update();
      _context.getPendingEntities().forEach((entity) {
        _entities.add(entity);
      });
      _context.clearPendingEntities();
      _entities.sync();
    });
  }

  void addEntity(Entity entity) {
    _context.addEntity(entity);
  }

  void addHud(Entity entity) {
    _context.addHud(entity);
  }

  void addUnit(Entity entity) {
    _context.addUnit(entity);
  }

  /// 画面からのポインタに関するイベントを受け取る
  void onPointerEvent(UiPointerEvent uiPointerEvent) {
    //_pointerEventHandler.handle(uiPointerEvent);

    uiPointerEvent.x =
        (uiPointerEvent.x / _camera.getZoom() + _camera.getRenderAdjustmentX());
    uiPointerEvent.y =
        (uiPointerEvent.y / _camera.getZoom() + _camera.getRenderAdjustmentY());

    Offset point = Offset(uiPointerEvent.x, uiPointerEvent.y);
    bool capturedEvent;

    _entities.whereLayer('hud').forEach((entity) {
      if (entity == null) {
        //TODO: 0件の場合NULLが渡される問題を直す
        return;
      }
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
    _entities.whereLayer('default').forEach((entity) {
      if (entity == null) {
        //TODO: 0件の場合NULLが渡される問題を直す
        return;
      }
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

  WorldContext get context => _context;

  ZOrderedCollection get entities {
    return _entities;
  }

  Camera get camera => _camera;
}
