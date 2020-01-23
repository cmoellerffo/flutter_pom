import 'package:flutter_pom/events/event.dart';

typedef void EventHandler(Event event);

class EventQueue<T> {
  Map<Type, List<EventHandler>> _eventCallbacks = {};


  void listen<T>(EventHandler callback) {
    if (_eventCallbacks.containsKey(T)) {
      _eventCallbacks[T].add(callback);
    } else {
      _eventCallbacks[T] = List<EventHandler>();
      _eventCallbacks[T].add(callback);
    }
  }

  void fire<T>(Event<T> event) {
    if (_eventCallbacks.containsKey(T)) {
      for (var e in _eventCallbacks[T]) {
        e(event);
      }
    }
  }

}