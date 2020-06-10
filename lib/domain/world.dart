import 'entity/entity.dart';

/// ゲームの本体。
/// ユーザーの入力などをデバイスに依存しない形で受け付ける
/// World単位でスローモーションにしたり高速化するなど
/// 時間軸を変更することが可能で、Worldはゲーム内に複数存在する可能性がある
class World {

  Entity _entity;

  int _randomSeed;  

  World({randomSeed: 0}): _randomSeed = randomSeed;

  void update(double dt) {
    _entity.update(dt);
  }

  void addEntity(Entity entity) {
    _entity = entity;
  }

  Entity get entity => _entity;
}
