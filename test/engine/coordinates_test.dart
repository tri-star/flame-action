import 'package:flame_action/engine/coordinates.dart';
import 'package:flutter_test/flutter_test.dart';

main() {


  group('Vector3d', () {

    test('toString', () {
      Vector3d v = Vector3d(1.0, 2.0, 3.0);
      expect(v.toString(), '1.0,2.0,3.0');
    });

    test('operator ==', () {
      Vector3d v = Vector3d(1.0, 2.0, 3.0);
      Vector3d v2 = Vector3d(1.0, 2.0, 3.0);
      expect(v == v2, true);
    });

  });

  group('Rect3d', () {

    group('isContain', () {

      Rect3d baseRect;
      setUp(() {
        baseRect = Rect3d.fromSizeAndPosition(Size3d(100, 200, 50), Position3d(0, 0, 0));
      });

      test('枠と同じサイズ', () {
        Rect3d targetRect = Rect3d.fromSizeAndPosition(Size3d(baseRect.w, baseRect.h, baseRect.d), Position3d(baseRect.x, baseRect.y, baseRect.z));
        expect(baseRect.isContain(targetRect), true);
      });
      test('左にはみ出している', () {
        Rect3d targetRect = Rect3d.fromSizeAndPosition(Size3d(baseRect.w, baseRect.h, baseRect.d), Position3d(baseRect.x-1, baseRect.y, baseRect.z));
        expect(baseRect.isContain(targetRect), false);
      });
      test('上にはみ出している', () {
        Rect3d targetRect = Rect3d.fromSizeAndPosition(Size3d(baseRect.w, baseRect.h, baseRect.d), Position3d(baseRect.x, baseRect.y-1, baseRect.z));
        expect(baseRect.isContain(targetRect), false);
      });
      test('右にはみ出している', () {
        Rect3d targetRect = Rect3d.fromSizeAndPosition(Size3d(baseRect.w+1, baseRect.h, baseRect.d), Position3d(baseRect.x, baseRect.y, baseRect.z));
        expect(baseRect.isContain(targetRect), false);
      });
      test('下にはみ出している', () {
        Rect3d targetRect = Rect3d.fromSizeAndPosition(Size3d(baseRect.w, baseRect.h+1, baseRect.d), Position3d(baseRect.x, baseRect.y, baseRect.z));
        expect(baseRect.isContain(targetRect), false);
      });
      test('手前にはみ出している', () {
        Rect3d targetRect = Rect3d.fromSizeAndPosition(Size3d(baseRect.w, baseRect.h, baseRect.d), Position3d(baseRect.x, baseRect.y, baseRect.z+1));
        expect(baseRect.isContain(targetRect), false);
      });
      test('奥にはみ出している', () {
        Rect3d targetRect = Rect3d.fromSizeAndPosition(Size3d(baseRect.w, baseRect.h, baseRect.d), Position3d(baseRect.x, baseRect.y, baseRect.z-1));
        expect(baseRect.isContain(targetRect), false);
      });
    });

  });

  group('getOverflowAdjustment', () {
      Rect3d baseRect;
      setUp(() {
        baseRect = Rect3d.fromSizeAndPosition(Size3d(100, 200, 50), Position3d(0, 0, 0));
      });

      test('枠と同じサイズ', () {
        Rect3d targetRect = Rect3d.fromSizeAndPosition(Size3d(baseRect.w, baseRect.h, baseRect.d), Position3d(baseRect.x, baseRect.y, baseRect.z));
        Vector3d adjustment = baseRect.getOverflowAdjustment(targetRect);
        expect(adjustment, Vector3d(0,0,0));
      });
      test('左にはみ出している場合', () {
        Rect3d targetRect = Rect3d.fromSizeAndPosition(Size3d(baseRect.w, baseRect.h, baseRect.d), Position3d(baseRect.x-1, baseRect.y, baseRect.z));
        Vector3d adjustment = baseRect.getOverflowAdjustment(targetRect);
        expect(adjustment, Vector3d(1,0,0));
      });

      test('上にはみ出している場合', () {
        Rect3d targetRect = Rect3d.fromSizeAndPosition(Size3d(baseRect.w, baseRect.h, baseRect.d), Position3d(baseRect.x, baseRect.y-1, baseRect.z));
        Vector3d adjustment = baseRect.getOverflowAdjustment(targetRect);
        expect(adjustment, Vector3d(0,1,0));
      });

      test('右にはみ出している場合', () {
        Rect3d targetRect = Rect3d.fromSizeAndPosition(Size3d(baseRect.w-1, baseRect.h, baseRect.d), Position3d(baseRect.x+2, baseRect.y, baseRect.z));
        Vector3d adjustment = baseRect.getOverflowAdjustment(targetRect);
        expect(adjustment, Vector3d(-1,0,0));
      });

      test('下にはみ出している場合', () {
        Rect3d targetRect = Rect3d.fromSizeAndPosition(Size3d(baseRect.w, baseRect.h-1, baseRect.d), Position3d(baseRect.x, baseRect.y+2, baseRect.z));
        Vector3d adjustment = baseRect.getOverflowAdjustment(targetRect);
        expect(adjustment, Vector3d(0,-1,0));
      });

      test('手前にはみ出している場合', () {
        Rect3d targetRect = Rect3d.fromSizeAndPosition(Size3d(baseRect.w, baseRect.h, baseRect.d), Position3d(baseRect.x, baseRect.y, baseRect.z+1));
        Vector3d adjustment = baseRect.getOverflowAdjustment(targetRect);
        expect(adjustment, Vector3d(0,0,-1));
      });

      test('奥にはみ出している場合', () {
        Rect3d targetRect = Rect3d.fromSizeAndPosition(Size3d(baseRect.w, baseRect.h, baseRect.d), Position3d(baseRect.x, baseRect.y, baseRect.z-1));
        Vector3d adjustment = baseRect.getOverflowAdjustment(targetRect);
        expect(adjustment, Vector3d(0,0,1));
      });

  });


}
