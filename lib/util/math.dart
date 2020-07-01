class MathUtil {
  /// 指定した値未満を数値を substituteで返す
  static double truncateUnder(
      double value, double threshold, double substitute) {
    return value >= threshold ? value : substitute;
  }

  /// 指定した値を超過する数値を substituteで返す
  static double roundUpOver(double value, double threshold, double substitute) {
    return value <= threshold ? value : substitute;
  }
}
