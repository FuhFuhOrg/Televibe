// chat_update_service.dart
import 'dart:convert';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';

class ChatUpdateService {
  static Future<List<(String, int)>> fetchUpdatedQueue(int queueId) async {
    List<(String, int)> queueChatNewMessages = [];

    // Получаем новые сообщения
    List<String>? newMessages = await NetServerController().getMessages(Chats.nowChat, queueId);
    if (newMessages != null && newMessages.isNotEmpty) {
      List<(String, int)> newMessagesFix = [];
      for (int i = 0; i < newMessages.length; i++) {
        if (newMessages[i] == "[]") {
          // Пропускаем пустые сообщения
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
      queueChat.addAll(queues);
      Chats.setNowChatQueue(queueChat, lastChangeId);
      return queueChat;
    }
    return Chats.getNowChatQueue();
  }
}
