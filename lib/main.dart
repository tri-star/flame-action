
import 'package:flutter/widgets.dart';

import 'application.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Application application = Application();

  runApp(application.widget);
}
