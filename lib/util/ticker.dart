import 'package:flutter/cupertino.dart';

/// FPS制御を行う
class Ticker {
  double _delta;

  static final double TICK_INTERVAL = 0.016;

  Ticker() : _delta = 0;

  void tick(double dt, VoidCallback callback) {
    _delta += dt;
    while (_delta >= TICK_INTERVAL) {
      callback();
      _delta -= TICK_INTERVAL;
    }
  }
}
