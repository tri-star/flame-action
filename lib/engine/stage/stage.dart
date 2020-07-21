import 'package:flutter/foundation.dart';

import '../camera.dart';
import '../world.dart';

abstract class Stage {
  @protected
  int money;

  @protected
  String state;

  void update(WorldContext context, Camera camera);

  int getMoneyAmmount() => money;
}
