import '../presentation/renderer.dart';

/// Canvasに直接レンダリングするEntityが実装する
mixin DirectRendering {
  Renderer getRenderer();
}
