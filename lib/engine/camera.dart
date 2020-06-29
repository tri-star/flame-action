import '../domain/entity/entity.dart';

class Camera {
  double _x;
  double _y;
  double _targetX;
  double _targetY;
  double _cameraW;
  double _cameraH;
  double _worldW;
  double _worldH;
  Entity _target;

  Camera(double cameraW, double cameraH, double worldW, double worldH)
      : _x = 0,
        _y = 0,
        _targetX = 0,
        _targetY = 0,
        _cameraW = cameraW,
        _cameraH = cameraH,
        _worldW = worldW,
        _worldH = worldH;

  double get x => _x;
  double get y => _y;
  double get w => _cameraW;
  double get h => _cameraH;

  void followEntity(Entity target) {
    _target = target;
  }

  void update() {
    if (_target != null) {
      _targetX = _getClippedX(_target.getX() - (_cameraW / 2));
      _targetY = _getClippedY(_target.getY() - (_cameraH / 2));
    }

    if ((_x - _targetX).abs() <= 5) {
      _x = _targetX;
    } else {
      _x += _x < _targetX ? 1 : -1;
    }
    if ((_y - _targetY).abs() <= 5) {
      _y += _y < _targetY ? 1 : -1;
    }
  }

  double _getClippedX(double x) {
    if (x < 0) {
      return 0;
    }
    if (x + _cameraW > _worldW) {
      return _worldW - _cameraW;
    }
    return x;
  }

  double _getClippedY(double y) {
    if (y < 0) {
      return 0;
    }
    if (y + _cameraH > _worldH) {
      return _worldH - _cameraH;
    }
    return y;
  }
}
