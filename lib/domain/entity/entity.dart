import 'package:flame/sprite.dart';

/// キャラクターやパーティクル、障害物、アイテムなど
/// ゲーム中に登場するオブジェクトのベースになるクラス
abstract class Entity {
  
  /// エンティティを一意に特定するID
  String _id = '';

  double _x = 0;
  double _y = 0;

  double _vx = 0;
  double _vy = 0;

  String _state = 'neutral';

  List<String> _tags = List<String>();

  String get id => _id;
  double get x => _x;
  double get y => _y;
  List<String> get tags => _tags;
  String get state => _state;

  void update(double dt) {
    throw new UnimplementedError();
  }

  //TODO: Flameに依存しないようにする
  Sprite get sprite => null;
}
