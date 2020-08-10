import 'dart:ui';

import 'package:flutter/animation.dart';

import '../../../util/ticker.dart';
import '../../camera.dart';
import 'wipe.dart';

//TODO: FadeOutとInでクラスを分けず、FadingWipeにまとめる

class FadeOutWipe extends Wipe {
  double opacity;
  double speed;
  Cubic _curve;

  FadeOutWipe(this.speed) : opacity = 0 {
    this.speed = speed < Ticker.TICK_INTERVAL ? Ticker.TICK_INTERVAL : speed;
    this._curve = Curves.easeOutExpo;
  }

  @override
  void render(Canvas canvas, Camera camera) {
    double screenW = camera.w;
    double screenH = camera.h;

    canvas.drawRect(
        Rect.fromLTWH(0, 0, camera.getRenderX(screenW, affectScroll: false),
            camera.getRenderX(screenH, affectScroll: false)),
        Paint()
          ..color = Color.fromARGB(
              (255 * this._curve.transform(opacity)).toInt(), 0, 0, 0));
  }

  @override
  void update() {
    if (isDone()) {
      return;
    }
    this.opacity += (Ticker.TICK_INTERVAL / speed);
    if (opacity > 1.0) {
      opacity = 1.0;
    }
  }

  @override
  bool isDone() {
    return opacity >= 1.0;
  }
}

class FadeInWipe extends Wipe {
  double opacity;
  double speed;
  Cubic _curve;

  FadeInWipe(this.speed) : opacity = 1 {
    this.speed = speed < Ticker.TICK_INTERVAL ? Ticker.TICK_INTERVAL : speed;
    this._curve = Curves.easeInExpo;
  }

  @override
  void render(Canvas canvas, Camera camera) {
    double screenW = camera.w;
    double screenH = camera.h;

    canvas.drawRect(
        Rect.fromLTWH(0, 0, camera.getRenderX(screenW, affectScroll: false),
            camera.getRenderX(screenH, affectScroll: false)),
        Paint()
          ..color = Color.fromARGB(
              (255 * this._curve.transform(opacity)).toInt(), 0, 0, 0));
  }

  @override
  void update() {
    if (isDone()) {
      return;
    }
    this.opacity -= (Ticker.TICK_INTERVAL / speed);
    if (opacity < 0) {
      opacity = 0;
    }
  }

  @override
  bool isDone() {
    return opacity <= 0;
  }
}
