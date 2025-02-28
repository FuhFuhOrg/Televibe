import 'dart:async';
import 'dart:convert';
import 'package:asn1lib/asn1lib.dart';
import 'package:flutter/widgets.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:convert/convert.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/export.dart' as crypto;
import 'package:tele_vibe/GettedData/cryptController.dart';
import 'dart:ui' as ui;

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

  static ChatData getChatById(String newChatId) {
    return _chats.chats.firstWhere((chat) => chat.chatId == newChatId, orElse: () => throw Exception('Chat not found'));
  }

  static List<(String, int)> getNowChatQueue (){
    if(_chats.chats.isEmpty){
      return [];
    }
    return _chats.chats.where((chat) => chat.chatId == nowChat).first?.queues?? [];
  }

  static void removeChat(String chatId) {
    ChatData chat = _chats.chats.firstWhere((chat) => chat.chatId == chatId);
    value.chats.remove(chat);
    
  }

  static void addUserInChat(String chatId, Subuser newUser) {
    ChatData chat = _chats.chats.firstWhere((chat) => chat.chatId == chatId);
    if(!chat.subusers.contains(newUser)){
      chat.subusers.add(newUser);
    }
  }

  static String getChatPassword(String chatId){
    ChatData chat = _chats.chats.firstWhere((chat) => chat.chatId == chatId);
    return chat.password;
  }

  static void setNowChatQueue (List<(String, int)> newValue, int newQueue) {
    if(newQueue == -1) return;

    var chat = _chats.chats.firstWhere(
      (chat) => chat.chatId == nowChat
    );

    if (chat != null) {
      chat.queues = newValue;
      chat.nowQueueId = newQueue;
    }

    return;
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

  // Преобразование в JSON (асинхронно)
  Future<Map<String, dynamic>> toJson() async {
    return {
      'chats': await Future.wait(chats.map((chat) => chat.toJson())),
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
  int? yourUserId;
  List<(String, int)> queues;
  List<Subuser> subusers; // Новый список подюзеров

  ChatData({
    required this.chatName,
    required this.chatId,
    required this.password,
    required this.nowQueueId,
    required this.chatIp,
    this.yourUserId,
    this.queues = const [],
    this.subusers = const [], // Инициализация пустым списком
  });

  // Преобразование в JSON
  Future<Map<String, dynamic>> toJson() async {
    return {
      'chatName': chatName,
      'chatId': chatId,
      'password': password,
      'nowQueueId': nowQueueId,
      'chatIp': chatIp,
      'yourUserId': yourUserId,
      'queues': await Future.wait(
          queues.map((queue) async => {'name': queue.$1, 'id': queue.$2})),
      'subusers': await Future.wait(subusers.map((subuser) => subuser.toJson())),
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
      yourUserId: json['yourUserId'],
      queues: (json['queues'] as List<dynamic>? ?? [])
          .map((queueJson) => (queueJson['name'] as String, queueJson['id'] as int))
          .toList(),
      subusers: (json['subusers'] as List<dynamic>? ?? [])
          .map((subuserJson) => Subuser.fromJson(subuserJson as Map<String, dynamic>))
          .toList(),
    );
  }

  // RW
  String getLastMessage() {
    return " ";
  }
}

class Subuser {
  int id;
  String userName;
  RSAPublicKey? publicKey;
  RSAPrivateKey privateKey;
  Image? image;

  Subuser({
    required this.id,
    required this.userName,
    required this.publicKey,
    required this.privateKey,
    required this.image,
  });

  // Преобразование Image в base64 String
  static Future<String> imageToBase64(Image image) async {
    ByteData? byteData = await imageToByteData(image);
    if (byteData == null) throw Exception("Ошибка при конвертации изображения в байты");
    Uint8List bytes = byteData.buffer.asUint8List();
    return base64Encode(bytes);
  }

  // Преобразование base64 String в Image
  static Image imageFromBase64(String base64String) {
    Uint8List bytes = base64.decode(base64String);
    return Image.memory(bytes);
  }

  // Конвертация Image в ByteData
  static Future<ByteData?> imageToByteData(Image image) async {
    final completer = Completer<ByteData?>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) async {
        ByteData? byteData = await info.image.toByteData(format: ui.ImageByteFormat.png);
        completer.complete(byteData);
      }),
    );
    return completer.future;
  }

  // Преобразование в JSON
  Future<Map<String, dynamic>> toJson() async {
    return {
      'id': id,
      'userName': userName,
      'publicKey': publicKey != null ? CryptController.encodePublicKey(publicKey!) : null,
      'privateKey': CryptController.encodePrivateKey(privateKey),
      'image': image != null ? await imageToBase64(image!) : null, // Ждём Future<String>
    };
  }

  // Преобразование из JSON
  factory Subuser.fromJson(Map<String, dynamic> json) {
    return Subuser(
      id: json['id'] as int,
      userName: json['userName'] as String? ?? 'Unknown',
      publicKey: json['publicKey'] != null
          ? CryptController.decodePublicKey(json['publicKey'] as String)
          : null,
      privateKey: CryptController.decodePrivateKey(json['privateKey'] as String),
      image: json['image'] != null ? imageFromBase64(json['image']) : null,
    );
  }
}
