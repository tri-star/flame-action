import 'package:flutter/cupertino.dart';
import 'ticker.dart';

class TimeoutTimer {
  double timeout;
  double _current;
  VoidCallback _callback;
  bool _finished;

  TimeoutTimer(this.timeout, {VoidCallback callback})
      : _current = 0,
        _finished = false,
        _callback = callback;

  void init(VoidCallback callback) {
    _current = 0;
    _finished = false;
    _callback = callback;
  }

  void update() {
    if (_finished) {
      return;
    }

    _current += Ticker.TICK_INTERVAL;

    if (isDone() && !_finished) {
      _finished = true;
      if (_callback != null) {
        _callback();
      }
    }
  }

  void reset() {
    this._current = 0;
    this._finished = false;
  }

  bool isDone() {
    return _current >= timeout;
  }
}
