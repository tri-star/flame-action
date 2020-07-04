import '../joystick.dart';
import '../../util/list.dart';

/// ゲーム用に変換済のInputイベントを各Entityに通知するサービス
class InputEventService {
  ZOrderedCollection _entities;

  InputEventService(ZOrderedCollection entities) : _entities = entities;

  /// 移動系のイベント(ゲーム用に変換済のもの)を各Entityに通知する。
  void notifyMoveEvent(InputMoveEvent event) {
    _entities.forEach((entity) {
      if (!(entity is GameInputListener)) {
        return;
      }
      (entity as GameInputListener).onInputMove(event);
    });
  }
}
