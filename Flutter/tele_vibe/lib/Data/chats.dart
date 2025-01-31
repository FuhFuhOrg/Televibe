import 'dart:async';
import 'dart:convert';
import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:convert/convert.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/export.dart' as crypto;

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
    if(_chats.chats.isEmpty){
      return List.empty();
    }
    return _chats.chats.where((chat) => chat.chatId == nowChat).first?.queues?? [];
  }

  static Subuser? getNowSubuser(){
    int? yourUserId = _chats.chats.where((chat) => chat.chatId == nowChat).first?.yourUserId;
    if(yourUserId != null){
       Subuser? subuser = _chats.chats
        .firstWhere((chat) => chat.chatId == nowChat)
        ?.subusers
        .firstWhere((user) => user.id == yourUserId);
      if(subuser != null){
        return subuser;
      }
      return null;
    }
    return null;
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
  List<Subuser> subusers; // Новый список подюзеров

  ChatData({
    required this.chatName,
    required this.chatId,
    required this.password,
    required this.nowQueueId,
    required this.chatIp,
    this.users,
    this.yourUserId,
    this.queues = const [],
    this.subusers = const [], // Инициализация пустым списком
  });

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'chatName': chatName,
      'chatId': chatId,
      'password': password,
      'nowQueueId': nowQueueId,
      'chatIp': chatIp,
      'users': users?.toJson(),
      'yourUserId': yourUserId,
      'queues': queues,
      'subusers': subusers.map((subuser) => subuser.toJson()).toList(), // Преобразуем список подюзеров в JSON
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
      users: json['users'] != null ? Users.fromJson(json['users'] as Map<String, dynamic>) : null,
      yourUserId: json['yourUserId'],
      queues: (json['queues'] as List<dynamic>? ?? []).cast<String>(),
      subusers: (json['subusers'] as List<dynamic>? ?? [])
          .map((subuserJson) => Subuser.fromJson(subuserJson as Map<String, dynamic>))
          .toList(), // Конвертируем JSON обратно в объекты Subuser
    );
  }

  // RW
  String getLastMessage() {
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

class Subuser {
  int id;
  String userName;
  RSAPublicKey publicKey;
  RSAPrivateKey privateKey;

  Subuser({
    required this.id,
    required this.userName,
    required this.publicKey,
    required this.privateKey,
  });

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'publicKey': encodePublicKey(publicKey),
      'privateKey': encodePrivateKey(privateKey),
    };
  }

  // Преобразование из JSON
  factory Subuser.fromJson(Map<String, dynamic> json) {
    return Subuser(
      id: json['id'] as int,
      userName: json['userName'] as String? ?? 'Unknown',
      publicKey: decodePublicKey(json['publicKey'] as String),
      privateKey: decodePrivateKey(json['privateKey'] as String),
    );
  }
}


// Кодирование публичного ключа в PEM-формат
String encodePublicKey(RSAPublicKey publicKey) {
  return publicKey.toString();
}

// Кодирование приватного ключа в PEM-формат
String encodePrivateKey(RSAPrivateKey privateKey) {
  return privateKey.toString();
}

// Декодирование публичного ключа из PEM
RSAPublicKey decodePublicKey(String pem) {
  final parser = null;
  return parser.parse(pem) as RSAPublicKey;
}

// Декодирование приватного ключа из PEM
RSAPrivateKey decodePrivateKey(String pem) {
  final parser = null;
  return parser.parse(pem) as RSAPrivateKey;
}