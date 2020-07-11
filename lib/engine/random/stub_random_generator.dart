import 'random_generator.dart';

class StubRandomGenerator extends RandomGenerator {
  List<int> _nextNumbers = [];

  void setNumbers(List<int> numbers) {
    _nextNumbers = numbers;
  }

  @override
  int getIntBetween(int min, int max) {
    int value = _nextNumbers.removeAt(0);
    assert(value != null, '');
    return value;
  }
}
