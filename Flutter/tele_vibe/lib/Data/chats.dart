import 'dart:async';

import 'package:pointycastle/asymmetric/api.dart';

class Chats {
  // Это локальная переменная
  static ChatCollection _chats = ChatCollection();
  // Это геттер
  static ChatCollection get value => _chats;
  // Это контроллеры подписок
  static final StreamController<ChatCollection> _controller = StreamController<ChatCollection>.broadcast();
  // Это Подписки
  static Stream<ChatCollection> get onValueChanged => _controller.stream;
  static String nowChat = "0";

  static void setValue(ChatCollection newValue) {
    _chats = newValue;
    _controller.add(_chats);
  }

  static void addChat(ChatData newValue) {
    _chats.addChat(newValue);
    _controller.add(_chats);
  }

  static ChatCollection getValue() {
    return _chats;
  }

  static List<String> getNowChatQueue (){
    return _chats.chats.where((chat) => chat.chatId == nowChat).first?.queues?? [];
  }
}

class ChatCollection {
  List<ChatData> chats;

  ChatCollection({List<ChatData>? chats}) : chats = chats ?? [];

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'chats': this.chats.map((chat) => chat.toJson()).toList(),
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
  List<String> queues;

  ChatData({
    required this.chatName,
    required this.chatId,
    required this.password,
    required this.nowQueueId,
    required this.chatIp,
    this.users,
    this.yourUserId,
    this.queues = const [],
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
      'queues': queues, // Список всегда преобразуется, даже если он пустой
    };
  }

  // Преобразование из JSON
  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      chatName: json['chatName'] as String,
      chatId: json['chatId'] as String,
      password: json['password'] as String,
      nowQueueId: json['nowQueueId'] as int,
      chatIp: json['chatIp'] as String,
      users: json['users'] != null ? Users.fromJson(json['users'] as Map<String, dynamic>) : null, // Проверяем, есть ли данные для Users
      yourUserId: json['yourUserId'], // Может быть null
      queues: (json['queues'] as List<dynamic>? ?? []).cast<String>(), // Преобразуем в список строк
    );
  }

  //RW
  String getLastMessage(){
    return " ";
  }
}

class Users {
  late int id;
  late String username;
  late (RSAPublicKey pub, RSAPrivateKey priv) keyPair;

  Users({
    required this.id,
    required this.username,
    required this.keyPair,
  });

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'keyPair': keyPair,
    };
  }

  // Преобразование из JSON
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      username: json['username'],
      keyPair: json['keyPair'],
    );
  }
}
