import 'package:flutter/foundation.dart';

/// HPゲージを持つユニット用のmixin
mixin FightingUnit {
  @protected
  double maxHp;

  @protected
  double hp;

  double getHp() => hp;

  void damage(double damage) {
    hp -= damage;
  }

  bool isDead() => hp > 0;
}
