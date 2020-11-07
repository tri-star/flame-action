import 'package:flutter/foundation.dart';

import '../camera.dart';
import '../world.dart';

enum StageState { STATE_PLAYING, STATE_CLEAR }

abstract class Stage {
  @protected
  StageState state;

  void update(WorldContext context, Camera camera);

  bool isCleared() => state == StageState.STATE_CLEAR;
}
