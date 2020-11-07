import '../../../engine/entity/entity.dart';
import '../../../engine/entity/entity_command.dart';
import '../../../engine/world.dart';

class CommonCommandAttack extends EntityCommand {
  CommonCommandAttack(Entity target) : super(target);

  @override
  bool execute(WorldContext context) {
    if (!target.changeState('attack')) {
      return false;
    }
    return true;
  }
}
