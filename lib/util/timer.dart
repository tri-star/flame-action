class TimeoutTimer {
  double timeout;
  double _current;

  TimeoutTimer(this.timeout) : _current = 0;

  void update() {
    //TODO: 1フレームの正式な値で更新する(定数など)
    _current += 0.016;
  }

  void reset() {
    this._current = 0;
  }

  bool isDone() {
    return _current >= timeout;
  }
}
