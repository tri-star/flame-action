/// 座標に関するユーティリティ関数
class CoordinateUtil {
  static bool isLineOverwrapped(double x1, double w1, double x2, double w2) {
    if (x1 > x2 + w2) {
      return false;
    }
    if (x2 > x1 + w1) {
      return false;
    }
    return true;
  }
}
