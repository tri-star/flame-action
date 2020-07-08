import 'package:flutter/foundation.dart';

import '../../engine/entity/entity.dart';
import '../../engine/world.dart';

/// ビヘイビアツリーの中で最終的に決定される実行可能なコマンド
abstract class BehaviourTask {
  /// タスクの日本語の名前
  @protected
  String name;

  String getName() => name;

  /// タスクを実行する
  void execute(WorldContext context, Entity entity);
}
