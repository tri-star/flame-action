

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
    return other is Position3d && 
      x == other.x &&
      y == other.y &&
      z == other.z;
  }
}

/// 物体の移動量を表すオブジェクト
class Vector3d {
  double x;
  double y;
  double z;

  Vector3d(this.x, this.y, this.z);

  bool isEqual(Vector3d target) {
    return x == target.x &&
      y == target.y &&
      z == target.z;
  }

  String toString() {
    return '$x,$y,$z';
  }

  @override
  bool operator ==(other) {
    return other is Vector3d && 
      x == other.x &&
      y == other.y &&
      z == other.z;
  }
}


/// 物体の大きさを表すオブジェクト
class Size3d {
  double w;
  double h;
  double d;

  Size3d(this.w, this.h, this.d);

}


class Rect3d {

  double _x;
  double _y;
  double _z;

  double _w;
  double _h;
  double _d;

  Rect3d(double x, double y, double z, double w, double h, double d):
    _x = x,
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
    if(target.x < _x) {
      return false;
    }
    if(target.y < _y) {
      return false;
    }
    if(target.x + target.w > _w + _x) {
      return false;
    }
    if(target.y + target.h > _y + _h) {
      return false;
    }
    if(target.z < _z) {
      return false;
    }
    if(target.z + target.d > _z + _d) {
      return false;
    }

    return true;
  }

  /// 指定したオブジェクトと衝突しているかを返す
  bool isIntersect(Rect3d target) {
    if(right <= target.x) {
      return false;
    }
    if(_x >= target.right) {
      return false;
    }
    if(bottom <= target.y) {
      return false;
    }
    if(_y >= target.bottom) {
      return false;
    }
    if(rear <= target.z) {
      return false;
    }
    if(z >= target.rear) {
      return false;
    }
    return true;
  }

  /// オブジェクトが自身の中に収まるために必要な移動量を返す
  Vector3d getOverflowAdjustment(Rect3d target) {
    double adjustX = 0;
    double adjustY = 0;
    double adjustZ = 0;
    if(target.x < _x) {
      adjustX = _x - target.x;
    }
    if(target.y < _y) {
      adjustY = _y - target.y;
    }
    if(target.right > right) {
      adjustX = right - target.right;
    }
    if(target.bottom > bottom) {
      adjustY = bottom - target.bottom;
    }
    if(target.z < _z) {
      adjustZ = _z - target.z;
    }
    if(target.rear > rear) {
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

}
