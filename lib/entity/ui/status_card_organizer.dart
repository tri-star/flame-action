import '../../engine/entity/entity.dart';
import '../../engine/world.dart';
import '../player.dart';
import 'status_card.dart';

class CardPosition {
  int position;
  Entity entity;

  CardPosition(this.entity, this.position);
}

class StatusCardOrganizer extends Entity {
  Map<int, CardPosition> _cards;

  StatusCardOrganizer(int id) {
    this.id = id;
    this.entityName = 'status_card_organizer';
    this._cards = Map<int, CardPosition>();
  }

  @override
  void update(WorldContext context) {
    context.huds.forEach((entity) {
      if ((entity is StatusCard) && !_cards.containsKey(entity.getId())) {
        _cards[entity.getId()] = CardPosition(entity, 0);
      }
    });

    List<int> removeIds = [];
    _cards.forEach((entityId, CardPosition cardPosition) {
      if (cardPosition.entity.isDisposed()) {
        removeIds.add(entityId);
      }
    });
    removeIds.forEach((entityId) {
      _cards.remove(entityId);
    });
    _arrange();
  }

  void _arrange() {
    int position = 1;
    double baseY = 10;
    double baseX = 10;
    double offsetX = 160;
    _cards.forEach((int id, CardPosition cardPosition) {
      if ((cardPosition.entity as StatusCard).getTarget() is Player) {
        cardPosition.position = 0;
      } else {
        cardPosition.position = position++;
      }
      (cardPosition.entity as StatusCard)
          .setTargetPosition(baseX + (cardPosition.position * offsetX), baseY);
    });
  }
}
