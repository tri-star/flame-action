import 'dart:ui';

import '../../domain/entity/ui/status_card.dart';
import '../../engine/camera.dart';
import '../../engine/entity/figting_unit.dart';
import '../../engine/image/sprite.dart';
import '../../engine/presentation/flame/flame_sprite_sheet.dart';
import '../../engine/presentation/renderer.dart';

class StatusCardRenderer extends Renderer<StatusCard> {
  final double CARD_OPACITYT = 0.8;

  final Map<String, int> _faceIndexMapping = {'player': 0, 'enemy01': 1};

  static FlameSpriteSheet _faceSpriteSheet;

  StatusCardRenderer() {
    if (_faceSpriteSheet == null) {
      _faceSpriteSheet = FlameSpriteSheet('faces.png', 20, 20, 5, 1);
    }
  }

  @override
  void render(Canvas canvas, Camera camera, StatusCard subject) {
    double cardOpacity = ((subject.getOpacity() / 100) * CARD_OPACITYT);

    double drawX = subject.getX();
    double drawY = subject.getY();
    canvas.drawRect(
        Rect.fromLTWH(
            subject.getX(), subject.getY(), subject.getW(), subject.getH()),
        Paint()..color = Color.fromRGBO(80, 80, 80, cardOpacity));

    drawX += 5;
    drawY += 5;
    canvas.drawRect(Rect.fromLTWH(drawX, drawY, 25, 25),
        Paint()..color = Color.fromRGBO(200, 200, 200, cardOpacity));

    int faceIndex = _faceIndexMapping[subject.getTarget().getEntityName()];
    Sprite sprite = _faceSpriteSheet.getSpriteByIndex(faceIndex);
    if (sprite != null) {
      // TODO: 座標の指定の仕方を工夫する
      sprite.x = drawX + 2;
      sprite.y = drawY + 2;
      // TODO: Sprite内で半透明の制御を隠蔽する
      sprite.paint = Paint()
        ..colorFilter = ColorFilter.mode(
            Color.fromRGBO(255, 255, 255, cardOpacity), BlendMode.modulate);
      sprite.render(canvas, null);
    }

    drawX += 30;

    canvas.drawRect(Rect.fromLTWH(drawX, drawY, subject.getW() - 40, 10),
        Paint()..color = Color.fromRGBO(255, 0, 0, cardOpacity));

    double rate = (subject.getTarget() as FightingUnit).getRestHpRate();
    canvas.drawRect(
        Rect.fromLTWH(drawX, drawY, (subject.getW() - 40) * rate, 10),
        Paint()..color = Color.fromRGBO(0, 255, 0, cardOpacity));
  }
}
