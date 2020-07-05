import 'dart:ui';

import 'package:flame_action/engine/entity/figting_unit.dart';
import 'package:flame_action/engine/world.dart';
import 'package:flutter/material.dart';

import '../../../engine/camera.dart';
import '../../../engine/entity/direct_rendering.dart';
import '../../../engine/entity/entity.dart';

class StatusCard extends Entity with DirectRendering {
  Entity _target;
  double _opacity;

  final double CARD_OPACITYT = 80;

  StatusCard(int id, Entity target, {double x, double y}) {
    assert(target != null);
    this.id = id;
    this.spriteResolver = spriteResolver;
    this.x = x;
    this.y = y;
    this._target = target;
    this._opacity = 0;
    this.state = 'fade-in';
  }

  @override
  void update(double dt, WorldContext context) {
    if (state == 'fade-in' && _opacity < 100) {
      _opacity += 3;
      if (_opacity >= 100) {
        state = 'neutral';
        _opacity = 100;
      }
    }
    if (state == 'neutral' && (_target as FightingUnit).isDead()) {
      state = 'fade-out';
    }
    if (state == 'fade-out' && _opacity > 0) {
      _opacity -= 3;
      if (_opacity <= 0) {
        dispose();
      }
    }
  }

  @override
  double getW() => 150;
  @override
  double getH() => 30;

  @override
  void renderDirect(Canvas canvas, Camera camera) {
    canvas.drawRect(
        Rect.fromLTWH(x, y, getW(), getH()),
        Paint()
          ..color =
              Color.fromRGBO(80, 80, 80, (_opacity * CARD_OPACITYT) / 100));

    canvas.drawRect(Rect.fromLTWH(x + 5, y + 5, getW() - 10, 10),
        Paint()..color = Color.fromRGBO(255, 0, 0, 1));

    double rate = (_target as FightingUnit).getRestHpRate();
    canvas.drawRect(Rect.fromLTWH(x + 5, y + 5, (getW() - 10) * rate, 10),
        Paint()..color = Color.fromRGBO(0, 255, 0, 1));
  }
}
