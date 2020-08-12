import '../../engine/presentation/renderer.dart';
import '../../engine/world.dart';

import '../../engine/entity/direct_rendering.dart';
import '../../engine/entity/entity.dart';

class Mask extends Entity with DirectRendering {
  double _opacity;
  Renderer _renderer;

  Mask(int id, Renderer renderer) {
    this.id = id;
    this.entityName = 'mask';
    this.spriteResolver = spriteResolver;
    this.layer = 'ui';
    this._opacity = 0.0;
    this.state = 'neutral';
    this._renderer = renderer;
    this.tags = [];
  }

  @override
  Renderer getRenderer() => _renderer;

  double get opacity => _opacity;

  @override
  void update(WorldContext context) {
    if (_opacity < 0.70) {
      _opacity += 0.01;
    }
  }
}
