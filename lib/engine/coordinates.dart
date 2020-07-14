import 'dart:math';

/// 物体の座標を表すオブジェクト
class Position3d {
  double x;
  double y;
  double z;

  Position3d(this.x, this.y, this.z);

  String toString() {
    return '$x,$y,$z';
  }

  @override
  bool operator ==(other) {
    return other is Position3d && x == other.x && y == other.y && z == other.z;
  }
}

/// 物体の移動量を表すオブジェクト
class Vector3d {
  double x;
  double y;
  double z;

  Vector3d(this.x, this.y, this.z);

  bool isEqual(Vector3d target) {
    return x == target.x && y == target.y && z == target.z;
  }

  String toString() {
    return '$x,$y,$z';
  }

  @override
  bool operator ==(other) {
    return other is Vector3d && x == other.x && y == other.y && z == other.z;
  }
}

/// 物体の大きさを表すオブジェクト
class Size3d {
  double w;
  double h;
  double d;

  Size3d(this.w, this.h, this.d);
}

/// 衝突の方向
enum IntersectDimension { BOTTOM, TOP, LEFT, RIGHT, REAR, FRONT }

class Rect3d {
  double _x;
  double _y;
  double _z;

  double _w;
  double _h;
  double _d;

  Rect3d(double x, double y, double z, double w, double h, double d)
      : _x = x,
        _y = y,
        _z = z,
        _w = w,
        _h = h,
        _d = d;

  factory Rect3d.fromSizeAndPosition(Size3d size, Position3d position) {
    return Rect3d(position.x, position.y, position.z, size.w, size.h, size.d);
  }

  /// 指定したオブジェクトが自分の中に収まっているかどうかを返す
  bool isContain(Rect3d target) {
    if (target.x < _x) {
      return false;
    }
    if (target.y < _y) {
      return false;
    }
    if (target.x + target.w > _w + _x) {
      return false;
    }
    if (target.y + target.h > _y + _h) {
      return false;
    }
    if (target.z < _z) {
      return false;
    }
    if (target.z + target.d > _z + _d) {
      return false;
    }

    return true;
  }

  /// 指定したオブジェクトと衝突しているかを返す
  bool isIntersect(Rect3d target) {
    if (right <= target.x) {
      return false;
    }
    if (_x >= target.right) {
      return false;
    }
    if (bottom <= target.y) {
      return false;
    }
    if (_y >= target.bottom) {
      return false;
    }
    if (rear <= target.z) {
      return false;
    }
    if (z >= target.rear) {
      return false;
    }
    return true;
  }

  Rect3d getIntersection(Rect3d target) {
    double left = max(_x, target.x) - _x;
    double width = min(right, target.right) - max(_x, target.x);
    double top = max(_y, target.y) - _y;
    double height = min(bottom, target.bottom) - max(_y, target.y);
    double front = max(_z, target.z) - _z;
    double depth = min(rear, target.rear) - max(_z, target.z);

    return Rect3d(left, top, front, width, height, depth);
  }

  /// 衝突の方向を返す
  /// 完全に重なっている場合などではあまり適切ではない値を返す可能性がある
  IntersectDimension getIntersectDimension(Rect3d target) {
    Rect3d intersection = getIntersection(target);

    if (intersection.d < intersection.w && intersection.d < intersection.h) {
      if (intersection.z >= (_d / 2)) {
        return IntersectDimension.FRONT;
      } else {
        return IntersectDimension.REAR;
      }
    }

    if (intersection.w < intersection.d && intersection.w < intersection.h) {
      if (intersection.x >= (_w / 2)) {
        return IntersectDimension.RIGHT;
      } else {
        return IntersectDimension.LEFT;
      }
    }

    if (intersection.h < intersection.w && intersection.h < intersection.d) {
      if (intersection.y >= (_h / 2)) {
        return IntersectDimension.BOTTOM;
      } else {
        return IntersectDimension.TOP;
      }
    }
    return null;
  }

  /// 衝突があった場合の調整分を返す
  /// 完全に重なっている場合などではあまり適切ではない値を返す可能性がある
  Vector3d getIntersectAdjustment(Rect3d target) {
    Rect3d intersection = getIntersection(target);
    IntersectDimension dimension = getIntersectDimension(target);
    switch (dimension) {
      case IntersectDimension.TOP:
        return Vector3d(0, intersection.h, 0);
      case IntersectDimension.LEFT:
        return Vector3d(intersection.w, 0, 0);
      case IntersectDimension.RIGHT:
        return Vector3d(-intersection.w, 0, 0);
      case IntersectDimension.BOTTOM:
        return Vector3d(0, -intersection.h, 0);
      case IntersectDimension.FRONT:
        return Vector3d(0, 0, -intersection.d);
      case IntersectDimension.REAR:
        return Vector3d(0, 0, intersection.d);
    }
    return Vector3d(0, 0, 0);
  }

  /// オブジェクトが自身の中に収まるために必要な移動量を返す
  Vector3d getOverflowAdjustment(Rect3d target) {
    double adjustX = 0;
    double adjustY = 0;
    double adjustZ = 0;
    if (target.x < _x) {
      adjustX = _x - target.x;
    }
    if (target.y < _y) {
      adjustY = _y - target.y;
    }
    if (target.right > right) {
      adjustX = right - target.right;
    }
    if (target.bottom > bottom) {
      adjustY = bottom - target.bottom;
    }
    if (target.z < _z) {
      adjustZ = _z - target.z;
    }
    if (target.rear > rear) {
      adjustZ = rear - target.rear;
    }
    return Vector3d(adjustX, adjustY, adjustZ);
  }

  double get x => _x;
  double get y => _y;
  double get z => _z;
  double get w => _w;
  double get h => _h;
  double get d => _d;

  double get right => _x + _w;
  double get bottom => _y + _h;
  double get rear => _z + _d;

  void setDepth(double newD) => _d = newD;
}
