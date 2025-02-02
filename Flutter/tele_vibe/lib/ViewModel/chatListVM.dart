


import 'dart:ffi';

import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/cryptController.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/api.dart'; // Импорт необходимых классов и интерфейсов
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/key_generators/api.dart' as keygen;
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';

class ChatListVM {


  List<Map<String, dynamic>> queueToFiltred(List<(String, int)> queueChat){
    List<Map<String, dynamic>> messages = [];

    for ((String, int) commandUserCode in queueChat) {

      ChatData cd = Chats.getValue().chats.firstWhere(
        (chat) => chat.chatId == Chats.nowChat
      );
      RSAPrivateKey privateKey = cd.subusers.firstWhere(
        (subuser) => subuser.id == commandUserCode.$2
      ).privateKey;

      String command = CryptController.decryptRSA(commandUserCode.$1, privateKey);
      if (command.startsWith('+')) {
        // Добавление нового сообщения
        messages.add({
          'text': command.substring(2), // Убираем '+ ' и оставляем текст
          if(commandUserCode.$2 == cd.yourUserId)
            'isMe': true
          else
            'isMe': false,
          'userName': 'Пользователь', // Можно добавить логику определения пользователя
          'time': '12:00' // Можно добавить актуальное время
        });
      } else if (command.startsWith('*')) {
        // Изменение сообщения
        List<String> parts = command.substring(2).split(' '); // Убираем '* ' и разделяем ID и новый текст
        int index = int.tryParse(parts[0]) ?? -1;
        if (index >= 0 && index < messages.length) {
          messages[index]['text'] = parts.sublist(1).join(' '); // Соединяем оставшуюся часть в новый текст
        }
      } else if (command.startsWith('-')) {
        // Удаление сообщения
        int index = int.tryParse(command.substring(2)) ?? -1; // Убираем '- ' и парсим ID
        if (index >= 0 && index < messages.length) {
          messages.removeAt(index);
        }
      }
    }

    return messages;
  }

  void sendMessage(String message){
    Subuser? subuser = Chats.getNowSubuser();
    if(subuser != null){
      NetServerController().sendMessage(message, Chats.nowChat, subuser.id, subuser.publicKey);
      return;
    }
    print("subuser is not available");
    return;
  }
}