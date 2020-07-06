import 'dart:ui';

import '../../domain/entity/ui/status_card.dart';
import '../../engine/camera.dart';
import '../../engine/entity/figting_unit.dart';
import '../../engine/presentation/renderer.dart';

class StatusCardRenderer extends Renderer<StatusCard> {
  final double CARD_OPACITYT = 0.8;

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

    drawX += 30;

    canvas.drawRect(Rect.fromLTWH(drawX, drawY, subject.getW() - 40, 10),
        Paint()..color = Color.fromRGBO(255, 0, 0, cardOpacity));

    double rate = (subject.getTarget() as FightingUnit).getRestHpRate();
    canvas.drawRect(
        Rect.fromLTWH(drawX, drawY, (subject.getW() - 40) * rate, 10),
        Paint()..color = Color.fromRGBO(0, 255, 0, cardOpacity));
  }
}
