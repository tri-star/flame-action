import 'package:flutter/foundation.dart';

import '../engine/stage/stage.dart';

abstract class ActionStage extends Stage {
  @protected
  int killCount;

  ActionStage() : killCount = 0;

  void addKillCount(int amount) {
    killCount += amount;
  }

  int getKillCount() => killCount;
}
