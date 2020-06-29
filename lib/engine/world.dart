import 'package:flame_action/domain/entity/entity.dart';
import 'package:flame_action/domain/entity/joystick.dart';
import 'package:flame_action/domain/entity/action_button.dart';
import 'package:flame_action/engine/services/collision_detect_service.dart';
import 'package:flame_action/presentation/image/action_button_sprite_resolver.dart';
import 'package:flame_action/presentation/image/joystick_sprite_resolver.dart';
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

  WorldContext(this.collisionDetectService, this.entities):
    _pendingEntities = List<Entity>();

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
class World implements JoystickListener {

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

  World(double worldW, double worldH, double worldD, double cameraW, double cameraH, {randomSeed: 0}): 
    _randomSeed = randomSeed,
    _entities = ZOrderedCollection(),
    _pendingEntities = [],
    _huds = List<Entity>(),
    _camera = Camera(cameraW, cameraH, worldW, worldH + worldD),
    _worldRect = Rect3d.fromSizeAndPosition(Size3d(worldW, worldH, worldD), Position3d(0,0,0)),
    _boundaryAdjustmentService = BoundaryAdjustmentService() {
      _collisionDetectService = CollisionDetectService(_entities);
      _context = WorldContext(_collisionDetectService, _entities);
    }

  void update(double dt) {
    //TODO: firstで判定しなくても動作するようにする
    if(_entities.first == null) {
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
      Rect.fromLTWH(x-70.0, y-70.0, 140, 140),
      Rect.fromLTWH((_camera.w - 120)-30, y-30.0, 60, 60),
    );
    _pointerEventHandler.addListener('world', this);

    this._huds.add(JoyStick(3, JoyStickSpriteResolver(), x: x, y: y));
    this._huds.add(ActionButton(3, ActionButtonSpriteResolver(), x: _camera.w - 120, y: y));
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
  onJoystickMove(JoystickMoveEvent event) {
    _entities.forEach((entity) {
      if(entity is JoystickListener) {
        (entity as JoystickListener).onJoystickMove(event);
      }
    });
    _huds.forEach((entity) {
      if(entity is JoystickListener) {
        (entity as JoystickListener).onJoystickMove(event);
      }
    });
  }

  @override
  onJoystickAction(JoystickActionEvent event) {
    _entities.forEach((entity) {
      if(entity is JoystickListener) {
        (entity as JoystickListener).onJoystickAction(event);
      }
    });
    _huds.forEach((entity) {
      if(entity is JoystickListener) {
        (entity as JoystickListener).onJoystickAction(event);
      }
    });
  }


  ZOrderedCollection get entities {
    return _entities;
  }
  
  List<Entity> get huds => _huds;
  Camera get camera => _camera;
}
