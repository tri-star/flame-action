import 'package:flutter/cupertino.dart';

/// FPS制御を行う
class Ticker {
  double _delta;

  Ticker() : _delta = 0;

  void tick(double dt, VoidCallback callback) {
    _delta += dt;
    while (_delta >= 0.016) {
      callback();
      _delta -= 0.016;
    }
  }
}
