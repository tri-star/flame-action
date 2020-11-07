import 'package:flutter/foundation.dart';

import '../world.dart';
import 'entity.dart';

/// Entityに対して実行可能なコマンド
abstract class EntityCommand {
  @protected
  Entity target;

  @mustCallSuper
  EntityCommand(this.target);

  bool execute(WorldContext context);
}
