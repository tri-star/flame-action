import '../../../engine/entity/entity.dart';
import '../../../engine/entity/entity_command.dart';

class CommonCommandAttack extends EntityCommand {
  CommonCommandAttack(Entity target) : super(target);

  @override
  bool execute() {
    if (!target.changeState('attack')) {
      return false;
    }
    return true;
  }
}
