import 'dart:math';

import 'package:flutter/foundation.dart';

/// HPゲージを持つユニット用のmixin
mixin FightingUnit {
  @protected
  double maxHp;

  @protected
  double hp;

  double getHp() => hp;
  double getMaxHp() => hp;
  double getRestHpRate() => max(hp, 0) / maxHp;

  void damage(double damage) {
    hp -= damage;
  }

  bool isDead() => hp <= 0;
}
