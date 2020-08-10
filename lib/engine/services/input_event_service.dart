import '../../util/list.dart';
import '../input_event.dart';
import '../world.dart';

/// ゲーム用に変換済のInputイベントを各Entityに通知するサービス
class InputEventService {
  ZOrderedCollection _entities;

  InputEventService(ZOrderedCollection entities) : _entities = entities;

  /// 移動系のイベント(ゲーム用に変換済のもの)を各Entityに通知する。
  void notifyMoveEvent(WorldContext context, InputMoveEvent event) {
    _entities.forEach((entity) {
      if (!(entity is GameInputListener)) {
        return;
      }
      (entity as GameInputListener).onInputMove(context, event);
    });
  }

  /// アクション系のイベント(ゲーム用に変換済のもの)を各Entityに通知する。
  void notifyActionEvent(WorldContext context, InputActionEvent event) {
    _entities.forEach((entity) {
      if (!(entity is GameInputListener)) {
        return;
      }
      (entity as GameInputListener).onInputAction(context, event);
    });
  }
}
