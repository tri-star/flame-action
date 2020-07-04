import '../entity/entity.dart';
import '../input_event.dart';
import '../../util/list.dart';

/// ゲーム用に変換済のInputイベントを各Entityに通知するサービス
class InputEventService {
  ZOrderedCollection _entities;
  List<Entity> _huds;

  InputEventService(ZOrderedCollection entities, List<Entity> huds)
      : _entities = entities,
        _huds = huds;

  /// 移動系のイベント(ゲーム用に変換済のもの)を各Entityに通知する。
  void notifyMoveEvent(InputMoveEvent event) {
    _entities.forEach((entity) {
      if (!(entity is GameInputListener)) {
        return;
      }
      (entity as GameInputListener).onInputMove(event);
    });
    _huds.forEach((entity) {
      if (!(entity is GameInputListener)) {
        return;
      }
      (entity as GameInputListener).onInputMove(event);
    });
  }

  /// アクション系のイベント(ゲーム用に変換済のもの)を各Entityに通知する。
  void notifyActionEvent(InputActionEvent event) {
    _entities.forEach((entity) {
      if (!(entity is GameInputListener)) {
        return;
      }
      (entity as GameInputListener).onInputAction(event);
    });
    _huds.forEach((entity) {
      if (!(entity is GameInputListener)) {
        return;
      }
      (entity as GameInputListener).onInputAction(event);
    });
  }
}
