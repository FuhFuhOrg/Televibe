import 'dart:async';

class Chats {
  // Это локальная переменная
  static ChatsData _value = ChatsData();
  // Это геттер
  static ChatsData get value => _value;
  // Это контроллеры подписок
  static final StreamController<ChatsData> _controller = StreamController<ChatsData>.broadcast();
  // Это Подписки
  static Stream<ChatsData> get onValueChanged => _controller.stream;

  static void setValue(ChatsData newValue) {
    _value = newValue;
    _controller.add(_value);
  }
}

class ChatsData {
  List<String> chats = List.empty();
}