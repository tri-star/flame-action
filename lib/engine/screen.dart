import 'dart:math';
import 'dart:ui';

class ScreenAdjustment {
  double _screenW;
  double _screenH;
  double _deviceW;
  double _deviceH;
  double _zoom;
  Offset adjustment;

  ScreenAdjustment(
      double screenW, double screenH, double deviceW, double deviceH)
      : _screenW = screenW,
        _screenH = screenH,
        _deviceW = deviceW,
        _deviceH = deviceH {
    _zoom = calculateZoom();
    adjustment = calcurateAdjustment();
  }

  double calculateZoom() {
    double zoomW = (_deviceW / _screenW);
    double zoomH = (_deviceH / _screenH);
    return min(zoomW, zoomH);
  }

  Offset calcurateAdjustment() {
    double offsetX = ((_screenW * _zoom) - _deviceW) / 2;
    double offsetY = ((_screenH * _zoom) - _deviceH) / 2;
    return Offset(offsetX, offsetY);
  }

  double getScreenW() => _screenW;
  double getScreenH() => _screenH;
  double getZoom() => _zoom;
  Offset getAdjustment() => adjustment;
}
