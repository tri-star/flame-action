import 'package:flame_action/domain/entity/entity.dart';
import 'package:flame_action/engine/entity/base_entity_factory.dart';
import 'package:flame_action/engine/services/collision_detect_service.dart';
import 'package:flutter/painting.dart';

import 'camera.dart';
import 'coordinates.dart';
import 'image/sprite.dart';
import 'joystick.dart';
import 'services/boundary_adjustment_service.dart';
import '../util/list.dart';

class WorldContext {
  ZOrderedCollection entities;
  CollisionDetectService collisionDetectService;
  List<Entity> _pendingEntities;
  BaseEntityFactory entityFactory;

  WorldContext(this.collisionDetectService, this.entities, this.entityFactory)
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
class World implements GameInputListener {
  Sprite background;
  ZOrderedCollection _entities;
  List<Entity> _pendingEntities;
  List<Entity> _huds;
  PointerEventHandler _pointerEventHandler;
  BoundaryAdjustmentService _boundaryAdjustmentService;
  CollisionDetectService _collisionDetectService;
  WorldContext _context;
  Rect3d _worldRect;
  Camera _camera;

  int _randomSeed;

  World(double worldW, double worldH, double worldD, double cameraW,
      double cameraH, BaseEntityFactory entityFactory,
      {randomSeed: 0})
      : _randomSeed = randomSeed,
        _entities = ZOrderedCollection(),
        _pendingEntities = [],
        _huds = List<Entity>(),
        _camera = Camera(cameraW, cameraH, worldW, worldH + worldD),
        _worldRect = Rect3d.fromSizeAndPosition(
            Size3d(worldW, worldH, worldD), Position3d(0, 0, 0)),
        _boundaryAdjustmentService = BoundaryAdjustmentService() {
    _collisionDetectService = CollisionDetectService(_entities);
    _context = WorldContext(_collisionDetectService, _entities, entityFactory);
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

  void createJoystick(double x, double y) {
    // 横幅/縦幅またはRectの情報をEntityやSpriteから取得する
    _pointerEventHandler = PointerEventHandler(
      Rect.fromLTWH(x - 70.0, y - 70.0, 140, 140),
      Rect.fromLTWH((_camera.w - 120) - 30, y - 30.0, 60, 60),
    );
    _pointerEventHandler.addListener('world', this);

    this._huds.add(_context.entityFactory.create('joystick', x, y, 0));
    this._huds.add(
        _context.entityFactory.create('action_button', _camera.w - 120, y, 0));
  }

  void setBackground(Sprite _sprite) {
    background = _sprite;
  }

  /// 画面からのポインタに関するイベントを受け取る
  void onPointerEvent(UiPointerEvent uiPointerEvent) {
    _pointerEventHandler.handle(uiPointerEvent);
  }

  /// UIからのイベントをJoystickのイベントに変換した結果を受け取る
  @override
  onInputMove(InputMoveEvent event) {
    _entities.forEach((entity) {
      if (entity is GameInputListener) {
        (entity as GameInputListener).onInputMove(event);
      }
    });
    _huds.forEach((entity) {
      if (entity is GameInputListener) {
        (entity as GameInputListener).onInputMove(event);
      }
    });
  }

  @override
  onInputAction(InputActionEvent event) {
    _entities.forEach((entity) {
      if (entity is GameInputListener) {
        (entity as GameInputListener).onInputAction(event);
      }
    });
    _huds.forEach((entity) {
      if (entity is GameInputListener) {
        (entity as GameInputListener).onInputAction(event);
      }
    });
  }

  ZOrderedCollection get entities {
    return _entities;
  }

  List<Entity> get huds => _huds;
  Camera get camera => _camera;
}
