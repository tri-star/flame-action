import 'dart:math';

import 'random_generator.dart';

class NativeRandomGenerator extends RandomGenerator {
  Random _random;

  NativeRandomGenerator(int seed) {
    _random = Random(seed);
  }

  @override
  int getIntBetween(int min, int max) {
    return _random.nextInt(max - min) + min;
  }
}
