import '../../engine/entity/entity.dart';
import '../../engine/entity/entity_command.dart';

/// ニュートラル状態に戻すコマンド
class MakeNeutralCommand extends EntityCommand {
  MakeNeutralCommand(Entity target) : super(target);

  @override
  bool execute() {
    if (!target.changeState('neutral')) {
      return false;
    }
    target.setForce(x: 0, z: 0);
    return true;
  }
}

/// 歩いて移動用のコマンド
class WalkCommand extends EntityCommand {
  double x;
  double z;
  WalkCommand(Entity target, {this.x, this.z}) : super(target);

  @override
  bool execute() {
    if (!target.changeState('walk')) {
      return false;
    }
    target.setForce(x: x, z: z);

    if (x != null) {
      target.setDimension(x > 0 ? Dimension.RIGHT : Dimension.LEFT);
    }

    return true;
  }
}
