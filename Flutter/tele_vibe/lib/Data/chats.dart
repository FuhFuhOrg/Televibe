import 'dart:async';

class Chats {
  // Это локальная переменная
  static int _value = 0;
  // Это геттер
  static int get value => _value;
  // Это контроллеры подписок
  static final StreamController<int> _controller = StreamController<int>.broadcast();
  // Это Подписки
  static Stream<int> get onValueChanged => _controller.stream;

  static void setValue(int newValue) {
    _value = newValue;
    _controller.add(_value);
  }
}
