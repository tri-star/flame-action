import 'package:flame_action/engine/entity/figting_unit.dart';
import 'package:flame_action/engine/world.dart';

import '../../engine/entity/direct_rendering.dart';
import '../../engine/entity/entity.dart';
import '../../engine/presentation/renderer.dart';

class StatusCard extends Entity with DirectRendering {
  Entity _target;
  double _opacity;

  double _targetX;
  double _targetY;

  Renderer _renderer;

  StatusCard(int id, Entity target, Renderer renderer, {double x, double y}) {
    assert(target != null);
    this.id = id;
    this.entityName = 'status_card';
    this.spriteResolver = spriteResolver;
    this.x = x;
    this.y = y;
    this._targetX = x;
    this._targetY = y;
    this._target = target;
    this._opacity = 0;
    this.state = 'fade-in';
    this._renderer = renderer;
    this.tags = ['status-card'];
  }

  @override
  void update(WorldContext context) {
    x = _targetX;
    y = _targetY;
    if (state == 'fade-in' && _opacity < 100) {
      _opacity += 1;
      if (_opacity >= 100) {
        state = 'neutral';
        _opacity = 100;
      }
    }
    if (state == 'neutral' && (_target as FightingUnit).isDead()) {
      state = 'fade-out';
    }
    if (state == 'fade-out' && _opacity > 0) {
      _opacity -= 1;
      if (_opacity <= 0) {
        dispose();
      }
    }
  }

  @override
  double getW() => 150;
  @override
  double getH() => 35;

  Entity getTarget() => _target;
  double getOpacity() => _opacity;

  void setTargetPosition(double x, double y) {
    _targetX = x;
    _targetY = y;
  }

  @override
  Renderer getRenderer() => _renderer;
}
