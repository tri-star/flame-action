import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'camera.dart';
import 'presentation/wipe/wipe.dart';
import 'world.dart';

enum SceneState {
  /// 初期状態(データのロードなど)
  INITIAL,

  /// アクティブな状態(切り替え後のワイプの実行も含む)
  ACTIVE,

  /// シーン切り替えのためのワイプが終了した状態
  LEAVING,

  /// シーンの現在の状態
  LEAVE,
}

/// ゲームの画面状態を管理するクラス
abstract class Scene {
  /// シーンの現在の状態
  @protected
  SceneState state;

  @protected
  Wipe enteringWipe;

  @protected
  Wipe leavingWipe;

  /// シーン終了時に実行する関数
  @protected
  VoidCallback leaveCallback;

  @mustCallSuper
  Scene({this.enteringWipe, this.leavingWipe}) : state = SceneState.INITIAL;

  void setState(SceneState newState) {
    state = newState;
  }

  Future<void> update(WorldContext context, Camera camera) async {
    switch (state) {
      case SceneState.INITIAL:
        await onInitialize(context, camera);
        state = SceneState.ACTIVE;
        break;
      case SceneState.ACTIVE:
        if (!(enteringWipe?.isDone() ?? true)) {
          enteringWipe?.update();
        }
        break;
      case SceneState.LEAVING:
        if (leavingWipe != null) {
          if (leavingWipe.isDone()) {
            leaveCallback?.call();
            state = SceneState.LEAVE;
          }
          leavingWipe.update();
        }
        break;
      case SceneState.LEAVE:
        break;
    }
  }

  void render(Canvas canvas, Camera camera) {
    switch (state) {
      case SceneState.INITIAL:
        break;
      case SceneState.ACTIVE:
        if (!(enteringWipe?.isDone() ?? true)) {
          enteringWipe?.render(canvas, camera);
        }
        break;
      case SceneState.LEAVING:
        if (leavingWipe != null) {
          leavingWipe.render(canvas, camera);
        }
        break;
      case SceneState.LEAVE:
        break;
    }
  }

  bool isActive() {
    return state == SceneState.ACTIVE;
  }

  /// ワイプの実行中、アクティブ中など、何らか描画が必要な状態かどうかを返す
  bool isNeedRendering() {
    return state == SceneState.ACTIVE || state == SceneState.LEAVING;
  }

  /// シーンが終了したかを返す
  bool isLeft() {
    return state == SceneState.LEAVE;
  }

  /// シーンを終了状態にする(終了のワイプを開始する)
  void leave(VoidCallback callback) {
    state = SceneState.LEAVING;
    leaveCallback = callback;
  }

  /// シーンの初期化処理を行う。
  Future<void> onInitialize(WorldContext context, Camera camera);
}
