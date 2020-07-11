import 'package:flame_action/util/coordinates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoordinateUtil', () {
    group('isLineOverwrapped', () {
      double x1 = 100;
      double w1 = 200;
      Map<String, dynamic> patterns = {
        '線1が線2の右側にある': {'x2': 10.0, 'w2': 89.0, 'expected': false},
        '線1が線2の右端に少し重なっている': {'x2': 10.0, 'w2': 90.0, 'expected': true},
        '線2が線1の右端に少し重なっている': {'x2': 299.0, 'w2': 10.0, 'expected': true},
        '線2が線1の右側にある': {'x2': 301.0, 'w2': 10.0, 'expected': false},
      };

      patterns.forEach((title, pattern) {
        test(title, () {
          bool result = CoordinateUtil.isLineOverwrapped(
              x1, w1, pattern['x2'], pattern['w2']);
          expect(result, pattern['expected']);
        });
      });
    });
  });
}
