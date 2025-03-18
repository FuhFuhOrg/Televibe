// chat_update_service.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/Widgets/chatList.dart';

class ChatUpdateService {
  final BuildContext context;
  final NetServerController _netServerController;

  ChatUpdateService(this.context) : _netServerController = NetServerController();

  Future<void> updateQueue() async {
    try {
      final chat = Chats.getNowChat();
      if (chat == null) return;

      final lastChangeId = chat.lastChangeId;
      final response = await _netServerController.getMessages(chat.chatId, lastChangeId);
      
      if (response != null && response.isNotEmpty) {
        final jsonString = response.join(' ');
        final jsonData = jsonDecode(jsonString);
        if (jsonData['status'] == 'success') {
          final messages = jsonData['messages'] as List;
          if (messages.isNotEmpty) {
            final lastMessage = messages.last;
            final newLastChangeId = lastMessage['change_id'] as int;
            
            // Обновляем очередь и сохраняем lastChangeId
            Chats.setNowChatQueue(chat.queues, newLastChangeId);
            
            // Обрабатываем новые сообщения
            final updatedQueue = await Chats.queueToFiltred(chat.queues, context);
            if (updatedQueue.isNotEmpty && updatedQueue.length !=  ChatListPage.currentMessages.length) {
              // Обновляем UI через setState или другой механизм обновления
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const ChatListPage(),
                  ),
                );
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching updated queue: $e');
    }
  }

  static Future<List<(String, int)>> fetchUpdatedQueue(int queueId) async {
    List<(String, int)> queueChatNewMessages = [];

    List<String>? newMessages = await NetServerController().getMessages(Chats.nowChat, queueId);
    if (newMessages != null && newMessages.isNotEmpty) {
      List<(String, int)> newMessagesFix = [];
      for (int i = 0; i < newMessages.length; i++) {
        if (newMessages[i] == "[]") {
        } else if (newMessages[i][0] == "[") {
          newMessagesFix.add((newMessages[i], -1));
        } else {
          newMessagesFix[newMessagesFix.length - 1] =
              (newMessagesFix[newMessagesFix.length - 1].$1 + " " + newMessages[i], -1);
        }
      }
      queueChatNewMessages.addAll(newMessagesFix);

      int lastChangeId = -1;
      List<(String, int)> queues = [];
      for ((String, int) jsonString in queueChatNewMessages) {
        try {
          List<dynamic> decodedList = jsonDecode(jsonString.$1);
          List<Map<String, dynamic>> queueMap = [];
          if (decodedList.isNotEmpty && decodedList[0] is Map<String, dynamic>) {
            queueMap.addAll(List<Map<String, dynamic>>.from(decodedList));
          }
          for (int i = 0; i < queueMap.length; i++) {
            if (queueMap[i].containsKey("changeId") &&
                queueMap[i].containsKey("changeData") &&
                queueMap[i].containsKey("senderId")) {
              int changeId = queueMap[i]["changeId"];
              if (lastChangeId < changeId) {
                lastChangeId = changeId;
              }
              String changeData = queueMap[i]["changeData"].toString();
              int senderId = queueMap[i]["senderId"];
              queues.add((changeData, senderId));
            }
          }
        } catch (e) {
          print("Ошибка парсинга JSON: $e");
        }
      }

      List<(String, int)> queueChat = Chats.getNowChatQueue();
      if (queueChat.isEmpty) {
        queueChat = [];
      }
      for (var newMsg in queues) {
        bool exists = queueChat.any((msg) => msg.$1 == newMsg.$1 && msg.$2 == newMsg.$2);
        if (!exists) {
          queueChat.add(newMsg);
        }
      }
      Chats.setNowChatQueue(queueChat, lastChangeId);
      return queueChat;
    }
    return Chats.getNowChatQueue();
  }
}
