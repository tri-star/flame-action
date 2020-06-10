/// キャラクターやパーティクル、障害物、アイテムなど
/// ゲーム中に登場するオブジェクトのベースになるクラス
abstract class Entity {
  
  /// エンティティを一意に特定するID
  String _id;

  double _x;
  double _y;

  double _vx;
  double _vy;

  String _state;

  List<String> _tags;

  String get id => _id;
  double get x => _x;
  double get y => _y;
  List<String> get tags => _tags;
  String get state => _state;

  void update(double dt) {
    throw new UnimplementedError();
  }
}
