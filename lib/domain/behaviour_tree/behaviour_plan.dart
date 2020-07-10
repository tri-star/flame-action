import '../../engine/entity/entity.dart';
import '../../engine/world.dart';

/// ビヘイビアツリーの中で最終的に決定される実行プラン
/// 「プレイヤーの元に移動する」のような単位の、ある程度まとまった行動の
/// 実行が完了するまでを制御する
abstract class BehaviourPlan {
  /// プランの名前。デバッグ用
  String get name;

  /// プランを実行する
  void execute(WorldContext context, Entity entity);

  bool isDone();
}
