import 'dart:async';
import 'dart:convert';
import 'package:asn1lib/asn1lib.dart';
import 'package:flutter/material.dart';
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
import 'package:tele_vibe/Services/notification_service.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/GettedData/localDataSaveController.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart';

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
  static final NotificationService _notificationService = NotificationService();

  static void _sendNotification(String chatName, String message, {bool isNewMessage = false}) {
    String notificationMessage;
    if (isNewMessage) {
      // Получаем последнее сообщение из чата
      ChatData cd = _chats.chats.firstWhere(
        (chat) => chat.chatId == nowChat
      );
      if (cd.messages.isNotEmpty) {
        var lastMessage = cd.messages.last;
        String senderName = lastMessage['userName'].toString();
        String messageText = lastMessage['text'].toString();
        notificationMessage = '$senderName: $messageText';
      } else {
        notificationMessage = message;
      }
    } else {
      notificationMessage = message;
    }

    _notificationService.showChatUpdateNotification(
      chatName: chatName,
      message: notificationMessage,
      payload: 'chat:$nowChat',
    );
  }

  static void setValue(ChatCollection newValue) {
    _chats = newValue;
    _controller.add(_chats);
  }

  static void addChat(ChatData newValue) {
    _chats.addChat(newValue);
    _controller.add(_chats);
    _sendNotification(newValue.chatName, 'Новый чат создан');
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
    _sendNotification(chat.chatName, 'Чат удален');
    value.chats.remove(chat);
  }

  static void addUserInChat(String chatId, Subuser newUser) {
    ChatData chat = _chats.chats.firstWhere((chat) => chat.chatId == chatId);
    if(!chat.subusers.contains(newUser)){
      chat.subusers.add(newUser);
      _controller.add(_chats);
      _sendNotification(chat.chatName, 'Новый пользователь ${newUser.userName} присоединился к чату');
    }
  }

  static String getChatPassword(String chatId){
    ChatData chat = _chats.chats.firstWhere((chat) => chat.chatId == chatId);
    return chat.password;
  }

  static void setNowChatQueue(List<(String, int)> newValue, int newQueue) {
    if(newQueue == -1) return;

    var chat = _chats.chats.firstWhere(
      (chat) => chat.chatId == nowChat
    );

    if (chat != null) {
      chat.queues = newValue;
      chat.nowQueueId = newQueue;
      chat.lastChangeId = newQueue;
      LocalDataSave.saveChatsData();
    }
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

  static Future<List<Map<String, dynamic>>> queueToFiltred(List<(String, int)> queueChat, BuildContext context) async {
    ChatData cd = _chats.chats.firstWhere(
      (chat) => chat.chatId == nowChat
    );

    // Если у нас уже есть все сообщения, возвращаем их
    if (cd.lastProcessedQueueIndex >= queueChat.length) {
      return cd.messages;
    }

    // Обрабатываем только новые сообщения
    for (int i = cd.lastProcessedQueueIndex; i < queueChat.length; i++) {
      (String, int) commandUserCode = queueChat[i];
      String command = "ERROR READ MESSAGE";
      
      try {
        RSAPrivateKey privateKey = cd.subusers.firstWhere(
          (subuser) => subuser.id == commandUserCode.$2
        ).privateKey;
        command = CryptController.decryptRSA(commandUserCode.$1, privateKey);
      }
      catch(e) {
        try {
          bool x = await _getAllUsersInChat(context);
          RSAPrivateKey privateKey = cd.subusers.firstWhere(
            (subuser) => subuser.id == commandUserCode.$2
          ).privateKey;
          command = CryptController.decryptRSA(commandUserCode.$1, privateKey);
        }
        catch(e) {
          print(e);
          continue;
        }
      }

      if (command.startsWith('+')) {
        command = command.substring(2).trim();
        List<String> parts = command.split(' ');
        String timePart = parts[0];
        String messageText = command.substring(timePart.length).trim();

        cd.messages.add({
          'text': messageText,
          'isMe': commandUserCode.$2 == cd.yourUserId,
          'userName': commandUserCode.$2,
          'time': timePart,
          'id': i,
        });

        _sendNotification(cd.chatName, 'Новое сообщение', isNewMessage: true);
      } else if (command.startsWith('*')) {
        List<String> parts = command.substring(2).split(' ');
        int index = int.tryParse(parts[0]) ?? -1;
        if (index >= 0 && index < cd.messages.length) {
          cd.messages[index]['text'] = parts.sublist(1).join(' ');
        }
      } else if (command.startsWith('-')) {
        int messageId = int.tryParse(command.substring(2)) ?? -1;
        cd.messages.removeWhere((message) => message['id'] == messageId);
      }
    }

    // Обновляем индекс последнего обработанного сообщения
    cd.lastProcessedQueueIndex = queueChat.length;
    
    return cd.messages;
  }

  static Future<bool> _getAllUsersInChat(BuildContext context) async {
    List<String> goin = await NetServerController().getChatUser(nowChat);
    
    if (goin.isNotEmpty && goin != " ") {
      for(String item in goin){
        print('$item');
      }
      
      if (goin[0] == "true") {
        for (int i = 1; i < goin.length; i += 4) {
          int uid = int.parse(goin[i]);
          String item = CryptController.decryptPrivateKey(goin[i + 1], nowChat, getChatPassword(nowChat));
          RSAPrivateKey privateKey = CryptController.decodePrivateKey(item);
          String name = goin[i + 2];
          Image image = Subuser.imageFromBase64(goin[i + 3]);

          addUserInChat(
            nowChat,
            Subuser(
              id: uid,
              userName: name,
              publicKey: null,
              privateKey: privateKey,
              image: image,
            )
          );
        }
        LocalDataSave.saveChatsData();
      } else {
        MessageHandler.showAlertDialog(context, '${goin.join(" ")}');
      }
    }

    return true;
  }

  static ChatData? getNowChat() {
    try {
      return _chats.chats.firstWhere(
        (chat) => chat.chatId == nowChat,
      );
    } catch (e) {
      return null;
    }
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
  List<Subuser> subusers;
  List<Map<String, dynamic>> messages;
  int lastProcessedQueueIndex;
  int lastChangeId;

  ChatData({
    required this.chatName,
    required this.chatId,
    required this.password,
    required this.nowQueueId,
    required this.chatIp,
    this.yourUserId,
    this.queues = const [],
    this.subusers = const [],
    this.messages = const [],
    this.lastProcessedQueueIndex = 0,
    this.lastChangeId = -1,
  });

  // Преобразование в JSON
  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> json = {
      'chatName': chatName,
      'chatId': chatId,
      'password': password,
      'nowQueueId': nowQueueId,
      'chatIp': chatIp,
      'yourUserId': yourUserId,
      'queues': queues.map((queue) => {'name': queue.$1, 'id': queue.$2}).toList(),
      'messages': messages,
      'lastProcessedQueueIndex': lastProcessedQueueIndex,
      'lastChangeId': lastChangeId,
    };

    // Асинхронно обрабатываем subusers
    json['subusers'] = await Future.wait(subusers.map((subuser) => subuser.toJson()));
    
    return json;
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
      messages: (json['messages'] as List<dynamic>? ?? [])
          .map((messageJson) => messageJson as Map<String, dynamic>)
          .toList(),
      lastProcessedQueueIndex: json['lastProcessedQueueIndex'] as int? ?? 0,
      lastChangeId: json['lastChangeId'] as int? ?? -1,
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