import 'package:flame_action/domain/entity/player.dart';
import 'package:flame_action/engine/coordinates.dart';
import 'package:flame_action/engine/services/boundary_adjustment_service.dart';
import 'package:flame_action/presentation/image/stub_sprite_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  BoundaryAdjustmentService service = BoundaryAdjustmentService();

  group('adjust', () {
    Map<String, dynamic> patterns = {
      '調整不要なケース': {
        "initialPosition": Position3d(10, 20, 30),
        "expectedPosition": Position3d(10, 20, 30),
      },
      '左にはみ出して調整されるケース': {
        "initialPosition": Position3d(-1, 20, 30),
        "expectedPosition": Position3d(0, 20, 30),
      },
      '上にはみ出して調整されるケース_上下はこのサービスでは調整されない': {
        "initialPosition": Position3d(0, -1, 30),
        "expectedPosition": Position3d(0, -1, 30),
      },
      '右にはみ出して調整されるケース': {
        "initialPosition": Position3d(501, 0, 30),
        "expectedPosition": Position3d(500, 0, 30),
      },
      '下にはみ出して調整されるケース_上下はこのサービスでは調整されない': {
        "initialPosition": Position3d(500, 201, 30),
        "expectedPosition": Position3d(500, 201, 30),
      },
      '手前にはみ出して調整されるケース': {
        "initialPosition": Position3d(500, 200, 91),
        "expectedPosition": Position3d(500, 200, 90),
      },
      '奥にはみ出して調整されるケース': {
        "initialPosition": Position3d(500, 200, -1),
        "expectedPosition": Position3d(500, 200, 0),
      },
    };

    patterns.forEach((title, pattern) {
      test(title, () {
        Size3d worldSize = Size3d(600, 300, 100);
        Size3d playerSize = Size3d(100, 100, 10);
        Position3d initialPosition = pattern['initialPosition'];
        Position3d expectedPosition = pattern['expectedPosition'];

        StubSpriteResolver spriteResolver = StubSpriteResolver(
            w: playerSize.w, h: playerSize.h, d: playerSize.d);
        Player player = Player(0, spriteResolver,
            x: initialPosition.x, y: initialPosition.y, z: initialPosition.z)
          ..disableGravity();
        Rect3d worldRect =
            Rect3d.fromSizeAndPosition(worldSize, Position3d(0, 0, 0));

        player.update(0.16, null);
        service.adjust(worldRect, player);
        expect(player.getPosition(), expectedPosition);
      });
    });
  });
}
