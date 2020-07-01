import '../../domain/entity/entity.dart';

/// Entityの生成を担うオブジェクト
abstract class BaseEntityFactory {
  int _nextId = 0;

  Entity create(String key, double x, double y, double z,
      {Map<String, dynamic> options});

  int getNextId() => _nextId++;
}
