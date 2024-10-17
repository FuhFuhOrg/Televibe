import 'dart:async';

class Chats {
  // Это локальная переменная
  static ChatCollection _chats = ChatCollection();
  // Это геттер
  static ChatCollection get value => _chats;
  // Это контроллеры подписок
  static final StreamController<ChatCollection> _controller = StreamController<ChatCollection>.broadcast();
  // Это Подписки
  static Stream<ChatCollection> get onValueChanged => _controller.stream;

  static void setValue(ChatCollection newValue) {
    _chats = newValue;
    _controller.add(_chats);
  }

  static void addChat(ChatData newValue) {
    _chats.addChat(newValue);
    _controller.add(_chats);
  }
}

// Переименованный класс
class ChatCollection {
  late List<ChatData> chats;

  ChatCollection({this.chats = const []});

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'chats': chats.map((chat) => chat.toJson()).toList(),
    };
  }

  // Преобразование из JSON
  factory ChatCollection.fromJson(Map<String, dynamic> json) {
    return ChatCollection(
      chats: (json['chats'] as List).map((data) => ChatData.fromJson(data)).toList(),
    );
  }

  void addChat(ChatData newValue) {
    chats.add(newValue);
  }
}

class ChatData {
  late String chatName, password, chatIp, chatId;
  late int nowQueueId;
  Users? users;
  int? yourUserId;

  ChatData({
    required this.chatName,
    required this.chatId,
    required this.password,
    required this.nowQueueId,
    required this.chatIp,
    this.users,
    this.yourUserId,
  });

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'chatName': chatName,
      'chatId': chatId,
      'password': password,
      'nowQueueId': nowQueueId,
      'chatIp': chatIp,
      'users': users?.toJson(), // Если users не null, конвертируем его в JSON
      'yourUserId': yourUserId, // Может быть null, и это нормально
    };
  }

  // Преобразование из JSON
  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      chatName: json['chatName'],
      chatId: json['chatId'],
      password: json['password'],
      nowQueueId: json['nowQueueId'],
      chatIp: json['chatIp'],
      users: json['users'] != null ? Users.fromJson(json['users']) : null, // Проверяем, есть ли данные для Users
      yourUserId: json['yourUserId'] != null ? json['yourUserId'] as int : null, // Проверяем, есть ли yourUserId
    );
  }
}

class Users {
  late int id;
  late String username;

  Users({
    required this.id,
    required this.username,
  });

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
    };
  }

  // Преобразование из JSON
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      username: json['username'],
    );
  }
}
