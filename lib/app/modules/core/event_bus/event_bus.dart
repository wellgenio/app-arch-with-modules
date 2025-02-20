import 'dart:async';

class EventBus {
  static final EventBus _instance = EventBus._();

  EventBus._();

  factory EventBus() {
    return _instance;
  }

  final StreamController _streamController = StreamController.broadcast();

  void emit(event) {
    _streamController.add(event);
  }

  Stream on<T>() {
    return _streamController.stream.where((event) => event is T).cast<T>();
  }

  void dispose() {
    _streamController.close();
  }
}