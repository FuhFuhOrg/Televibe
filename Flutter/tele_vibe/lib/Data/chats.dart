import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/export.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart';
import 'package:tele_vibe/GettedData/cryptController.dart';
import 'package:tele_vibe/GettedData/localDataSaveController.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/Services/notification_service.dart';

class Chats {
  // Это переменная состояния
  static ChatCollection _chats = ChatCollection();
  // Это геттер
  static ChatCollection get value => _chats;
  // Это контроллеры подписок
  static final StreamController<ChatCollection> _controller =
      StreamController<ChatCollection>.broadcast();
  // Это Подписки
  static Stream<ChatCollection> get onValueChanged => _controller.stream;
  static String nowChat = "0";
  static final NotificationService _notificationService = NotificationService();

  static void _sendNotification(String chatName, String message,
      {bool isNewMessage = false}) {
    String notificationMessage;
    if (isNewMessage) {
      final chat = getNowChat();
      if (chat != null && chat.messages.isNotEmpty) {
        var lastMessage = chat.messages.last;
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
    _sendNotification(newValue.chatName, 'New chat created');
  }

  static ChatCollection getValue() {
    return _chats;
  }

  static ChatData getChatById(String newChatId) {
    return _chats.chats.firstWhere((chat) => chat.chatId == newChatId,
        orElse: () => throw Exception('Chat not found'));
  }

  static List<(String, int)> getNowChatQueue() {
    return getNowChat()?.queues ?? [];
  }

  static void removeChat(String chatId) {
    final chat = _findChatById(chatId);
    if (chat == null) return;
    _sendNotification(chat.chatName, 'Chat removed');
    value.chats.remove(chat);
    _controller.add(_chats);
  }

  static void addUserInChat(String chatId, Subuser newUser) {
    final chat = _findChatById(chatId);
    if (chat == null) return;
    if (!chat.subusers.any((subuser) => subuser.id == newUser.id)) {
      chat.subusers.add(newUser);
      _controller.add(_chats);
      _sendNotification(
          chat.chatName, 'New member ${newUser.userName} joined the chat');
    }
  }

  static String getChatPassword(String chatId) {
    return _findChatById(chatId)?.password ?? '';
  }

  static void setNowChatQueue(List<(String, int)> newValue, int newQueue) {
    if (newQueue == -1) return;

    final chat = getNowChat();
    if (chat == null) return;

    chat.queues = newValue;
    chat.nowQueueId = newQueue;
    chat.lastChangeId = newQueue;
    LocalDataSave.saveChatsData();
  }

  static Subuser? getNowSubuser() {
    final chat = getNowChat();
    int? yourUserId = chat?.yourUserId;
    if (yourUserId != null) {
      return _findSubuserById(chat, yourUserId);
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> queueToFiltred(
      List<(String, int)> queueChat, BuildContext context) async {
    final cd = getNowChat();
    if (cd == null) return [];

    // Если у нас уже есть все сообщения, возвращаем их
    if (cd.lastProcessedQueueIndex >= queueChat.length) {
      return cd.messages;
    }

    // Обрабатываем только новые сообщения
    for (int i = cd.lastProcessedQueueIndex; i < queueChat.length; i++) {
      (String, int) commandUserCode = queueChat[i];
      String command = "ERROR READ MESSAGE";

      try {
        final subuser = _findSubuserById(cd, commandUserCode.$2);
        if (subuser == null) continue;
        RSAPrivateKey privateKey = subuser.privateKey;
        // Декодируем base64 и UTF-8 перед RSA расшифровкой
        Uint8List decodedBytes = base64Decode(commandUserCode.$1);
        String decodedString = utf8.decode(decodedBytes);
        command = CryptController.decryptRSA(decodedString, privateKey);
      } catch (e) {
        try {
          await _getAllUsersInChat(context);
          final subuser = _findSubuserById(cd, commandUserCode.$2);
          if (subuser == null) continue;
          RSAPrivateKey privateKey = subuser.privateKey;
          // Декодируем base64 и UTF-8 перед RSA расшифровкой
          Uint8List decodedBytes = base64Decode(commandUserCode.$1);
          String decodedString = utf8.decode(decodedBytes);
          command = CryptController.decryptRSA(decodedString, privateKey);
        } catch (e) {
          developer.log('Failed to decrypt queued command', error: e);
          continue;
        }
      }

      if (command.startsWith('+')) {
        command = command.substring(2).trim();
        List<String> parts = command.split(' ');
        String timePart = parts[0];
        String messageText = command.substring(timePart.length).trim();

        // Проверяем, является ли сообщение изображением
        if (messageText.startsWith('<img>') && messageText.endsWith('</img>')) {
          // Извлекаем содержимое
          String content = messageText.substring(5, messageText.length - 6);

          try {
            // Разделяем на три части: зашифрованное начало, base64 изображения, зашифрованный конец
            List<String> parts = content.split('|');
            if (parts.length != 3) {
              throw Exception('Invalid encrypted image format');
            }

            // Расшифровываем начало и конец
            final subuser = _findSubuserById(cd, commandUserCode.$2);
            if (subuser == null) continue;
            RSAPrivateKey privateKey = subuser.privateKey;

            String startMarker =
                CryptController.decryptRSA(parts[0], privateKey);
            String endMarker = CryptController.decryptRSA(parts[2], privateKey);

            // Проверяем маркеры
            if (startMarker != "START" || endMarker != "END") {
              throw Exception('Invalid image markers');
            }

            // Центральная часть - само изображение в base64
            String base64Image = parts[1];

            cd.messages.add({
              'text': '[Image]',
              'isMe': commandUserCode.$2 == cd.yourUserId,
              'userName': commandUserCode.$2,
              'time': timePart,
              'id': i,
              'isImage': true,
              'imageData': base64Image,
            });
          } catch (e) {
            developer.log('Failed to decrypt image', error: e);
            continue;
          }
        } else {
          cd.messages.add({
            'text': messageText,
            'isMe': commandUserCode.$2 == cd.yourUserId,
            'userName': commandUserCode.$2,
            'time': timePart,
            'id': i,
            'isImage': false,
          });
        }

        _sendNotification(cd.chatName, 'New message', isNewMessage: true);
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

    if (goin.isNotEmpty && goin.any((item) => item.trim().isNotEmpty)) {
      for (String item in goin) {
        developer.log(item);
      }

      if (goin[0] == "true") {
        for (int i = 1; i < goin.length; i += 4) {
          if (i + 3 >= goin.length) break;
          int? uid = int.tryParse(goin[i]);
          if (uid == null) continue;
          String item = CryptController.decryptPrivateKey(
              goin[i + 1], nowChat, getChatPassword(nowChat));
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
              ));
        }
        LocalDataSave.saveChatsData();
      } else {
        if (!context.mounted) return false;
        MessageHandler.showAlertDialog(context, goin.join(" "));
      }
    }

    return true;
  }

  static ChatData? getNowChat() {
    return _findChatById(nowChat);
  }

  static ChatData? _findChatById(String chatId) {
    for (final chat in _chats.chats) {
      if (chat.chatId == chatId) return chat;
    }
    return null;
  }

  static Subuser? _findSubuserById(ChatData? chat, int userId) {
    if (chat == null) return null;
    for (final subuser in chat.subusers) {
      if (subuser.id == userId) return subuser;
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
      chats: (json['chats'] as List)
          .map((data) => ChatData.fromJson(data))
          .toList(),
    );
  }

  void addChat(ChatData newValue) {
    chats.add(newValue);
  }
}

class ChatData {
  late String chatName, password, chatIp, chatId;
  late int nowQueueId;
  String? avatarUrl;
  int? yourUserId;
  List<(String, int)> queues;
  List<Subuser> subusers;
  List<Map<String, dynamic>> messages;
  int lastProcessedQueueIndex;
  int lastChangeId;
  bool isPreparedData;
  bool isGroup;
  int unreadCount;
  bool isPinned;

  ChatData({
    required this.chatName,
    required this.chatId,
    required this.password,
    required this.nowQueueId,
    required this.chatIp,
    this.yourUserId,
    this.queues = const [],
    this.subusers = const [],
    List<Map<String, dynamic>>? messages,
    this.lastProcessedQueueIndex = 0,
    this.lastChangeId = -1,
    this.avatarUrl,
    this.isPreparedData = false,
    this.isGroup = false,
    this.unreadCount = 0,
    this.isPinned = false,
  }) : messages = messages ?? [];

  // Преобразование в JSON
  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> json = {
      'chatName': chatName,
      'chatId': chatId,
      'password': password,
      'nowQueueId': nowQueueId,
      'chatIp': chatIp,
      'yourUserId': yourUserId,
      'queues':
          queues.map((queue) => {'name': queue.$1, 'id': queue.$2}).toList(),
      'messages': messages,
      'lastProcessedQueueIndex': lastProcessedQueueIndex,
      'lastChangeId': lastChangeId,
      'avatarUrl': avatarUrl,
      'isPreparedData': isPreparedData,
      'isGroup': isGroup,
      'unreadCount': unreadCount,
      'isPinned': isPinned,
    };

    // Асинхронно обрабатываем subusers
    json['subusers'] =
        await Future.wait(subusers.map((subuser) => subuser.toJson()));

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
          .map((queueJson) =>
              (queueJson['name'] as String, queueJson['id'] as int))
          .toList(),
      subusers: (json['subusers'] as List<dynamic>? ?? [])
          .map((subuserJson) =>
              Subuser.fromJson(subuserJson as Map<String, dynamic>))
          .toList(),
      messages: (json['messages'] as List<dynamic>? ?? [])
          .map((messageJson) => messageJson as Map<String, dynamic>)
          .toList(),
      lastProcessedQueueIndex: json['lastProcessedQueueIndex'] as int? ?? 0,
      lastChangeId: json['lastChangeId'] as int? ?? -1,
      avatarUrl: json['avatarUrl'] as String?,
      isPreparedData: json['isPreparedData'] as bool? ?? false,
      isGroup: json['isGroup'] as bool? ?? false,
      unreadCount: json['unreadCount'] as int? ?? 0,
      isPinned: json['isPinned'] as bool? ?? false,
    );
  }

  // RW
  String getLastMessage() {
    if (messages.isEmpty) return 'No messages yet';
    final lastMessage = messages.last;
    final isImage = lastMessage['isImage'] == true;
    final text = isImage
        ? (lastMessage['caption']?.toString().isNotEmpty == true
            ? lastMessage['caption'].toString()
            : 'Photo')
        : (lastMessage['text']?.toString() ?? '');
    final userName = lastMessage['userName']?.toString() ?? '';
    final isMe = lastMessage['isMe'] == true;

    if (isMe) return 'You: $text';
    if (isGroup && userName.isNotEmpty) return '$userName: $text';
    return text;
  }

  String getLastMessageTime() {
    if (messages.isEmpty) return '';
    return messages.last['time']?.toString() ?? '';
  }
}

class Subuser {
  int id;
  String userName;
  RSAPublicKey? publicKey;
  RSAPrivateKey privateKey;
  Image? image;
  String? avatarUrl;

  Subuser({
    required this.id,
    required this.userName,
    required this.publicKey,
    required this.privateKey,
    required this.image,
    this.avatarUrl,
  });

  Image? getImage() {
    return image;
  }

  // Преобразование Image в base64 String
  static Future<String> imageToBase64(Image image) async {
    ByteData? byteData = await imageToByteData(image);
    if (byteData == null) {
      throw Exception('Failed to convert image to bytes');
    }
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
        ByteData? byteData =
            await info.image.toByteData(format: ui.ImageByteFormat.png);
        if (!completer.isCompleted) {
          completer.complete(byteData);
        }
      }),
    );
    return completer.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () => null,
    );
  }

  // Преобразование в JSON
  Future<Map<String, dynamic>> toJson() async {
    return {
      'id': id,
      'userName': userName,
      'publicKey': publicKey != null
          ? CryptController.encodePublicKey(publicKey!)
          : null,
      'privateKey': CryptController.encodePrivateKey(privateKey),
      'image': image != null
          ? await imageToBase64(image!)
          : null, // Ждём Future<String>
      'avatarUrl': avatarUrl,
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
      privateKey:
          CryptController.decodePrivateKey(json['privateKey'] as String),
      image: json['image'] != null ? imageFromBase64(json['image']) : null,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}
