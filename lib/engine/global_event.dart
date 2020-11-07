import 'world.dart';

class GlobalEvent {
  String type;
  Map<String, dynamic> payload;

  GlobalEvent(this.type, {this.payload});
}

mixin GlobalEventListener {
  void onGlobalEvent(WorldContext context, GlobalEvent event);
}

class GlobalEventBus {
  List<GlobalEventListener> _listeners;

  static GlobalEventBus _instance;

  factory GlobalEventBus.instance() {
    if (GlobalEventBus._instance == null) {
      GlobalEventBus._instance = GlobalEventBus._inner();
    }
    return GlobalEventBus._instance;
  }

  GlobalEventBus._inner() : _listeners = [];

  void notify(WorldContext context, GlobalEvent event) {
    _listeners.forEach((listener) {
      listener.onGlobalEvent(context, event);
    });
  }

  void addListener(GlobalEventListener listener) {
    _listeners.add(listener);
  }
}
