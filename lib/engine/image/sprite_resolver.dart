import 'package:flame_action/domain/entity/entity.dart';

import 'animation.dart';
import 'sprite.dart';

/// スプライトの決定に必要な情報
class SpriteContext {
  String state;
  Dimension dimension;

  SpriteContext({this.state, this.dimension});
}

/// アニメーションに必要な情報を受け取り、
/// 表示するべきスプライトを決定する
abstract class SpriteResolver {
  Sprite resolve(SpriteContext context);

  Animation resolveAnimation(SpriteContext context);

  void update();
}
