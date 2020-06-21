

class Position3d {
  double x;
  double y;
  double z;

  Position3d(this.x, this.y, this.z);
}


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

  double get x => _x;
  double get y => _y;
  double get z => _z;
  double get w => _w;
  double get h => _h;
  double get d => _d;

}
