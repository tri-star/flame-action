
import 'package:flutter/widgets.dart';

import 'engine/game_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GameWidget gameWidget = GameWidget();

  runApp(gameWidget.getWidget());
}
