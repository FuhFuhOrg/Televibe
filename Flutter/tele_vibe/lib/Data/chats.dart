import 'dart:async';

class Chats {
  // Это локальная переменная
  static ChatsData _chats = ChatsData();
  // Это геттер
  static ChatsData get value => _chats;
  // Это контроллеры подписок
  static final StreamController<ChatsData> _controller = StreamController<ChatsData>.broadcast();
  // Это Подписки
  static Stream<ChatsData> get onValueChanged => _controller.stream;

  static void setValue(ChatsData newValue) {
    _chats = newValue;
    _controller.add(_chats);
  }
}


// Тут нужно поменять названия , ато ChatsData и ChatData сливаются
class ChatsData {
  late List<ChatData> chats;

  ChatsData({this.chats = const []});

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'chats': chats.map((chat) => chat.toJson()).toList(),
    };
  }

  // Преобразование из JSON
  factory ChatsData.fromJson(Map<String, dynamic> json) {
    return ChatsData(
      chats: (json['chats'] as List).map((data) => ChatData.fromJson(data)).toList(),
    );
  }
}

class ChatData {
  late String chatName;
  late String message;
  late DateTime time;

  late int nowQueueId;

  // Конструктор
  ChatData({
    required this.chatName,
    required this.message,
    required this.time,
    required this.nowQueueId,
  });

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'chatName': chatName,
      'message': message,
      'time': time.toIso8601String(), // Преобразование даты в строку
      'nowQueueId': nowQueueId,
    };
  }

  // Преобразование из JSON
  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      chatName: json['chatName'],
      message: json['message'],
      time: DateTime.parse(json['time']), // Преобразование строки обратно в DateTime
      nowQueueId: json['nowQueueId'],
    );
  }
}