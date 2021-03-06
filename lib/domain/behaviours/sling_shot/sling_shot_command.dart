import '../../../engine/entity/entity.dart';
import '../../../engine/entity/entity_command.dart';

class SlingShotCommandAttack extends EntityCommand {
  SlingShotCommandAttack(Entity target) : super(target);

  @override
  bool execute() {
    if (!target.changeState('attack')) {
      return false;
    }
    return true;
  }
}
