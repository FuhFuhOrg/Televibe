


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
import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/Data/user.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart';
import 'package:tele_vibe/GettedData/cryptController.dart';
import 'package:tele_vibe/GettedData/localDataSaveController.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';

class ChatListVM {


  Future<List<Map<String, dynamic>>> queueToFiltred(List<(String, int)> queueChat, BuildContext context) async {
    List<Map<String, dynamic>> messages = [];
    int k = 0;

    for ((String, int) commandUserCode in queueChat) {

      ChatData cd = Chats.getValue().chats.firstWhere(
        (chat) => chat.chatId == Chats.nowChat
      );

      String command = "ERROR READ MESSAGE";
      try{
        RSAPrivateKey privateKey = cd.subusers.firstWhere(
          (subuser) => subuser.id == commandUserCode.$2
        ).privateKey;
        command = CryptController.decryptRSA(commandUserCode.$1, privateKey);
      }
      catch(e){
        try {
          bool x = await _getAllUsersInChat(context);

          RSAPrivateKey privateKey = cd.subusers.firstWhere(
            (subuser) => subuser.id == commandUserCode.$2
          ).privateKey;
          command = CryptController.decryptRSA(commandUserCode.$1, privateKey);
        }
        catch(e){
          print(e);
          continue;
        }
      }

      if (command.startsWith('+')) {
        // Добавление нового сообщения
        messages.add({
          'text': command.substring(2), // Убираем '+ ' и оставляем текст
          if(commandUserCode.$2 == cd.yourUserId)
            'isMe': true
          else
            'isMe': false,
          'userName': 'Пользователь', // Можно добавить логику определения пользователя
          'time': '12:00', // Можно добавить актуальное время
          'id': k
        });
      } else if (command.startsWith('*')) {
        // Изменение сообщения
        List<String> parts = command.substring(2).split(' '); // Убираем '* ' и разделяем ID и новый текст
        int index = int.tryParse(parts[0]) ?? -1;
        if (index >= 0 && index < messages.length) {
          messages[index]['text'] = parts.sublist(1).join(' '); // Соединяем оставшуюся часть в новый текст
        }
      } else if (command.startsWith('-')) {
        int messageId = int.tryParse(command.substring(2)) ?? -1; // Убираем '- ' и парсим ID

        messages.removeWhere((message) => message['id'] == messageId);
      }
      k++;
    }

    //Я выполняю квоту на комиты
    return messages;
  }

  Future<bool> _getAllUsersInChat(BuildContext context) async {
    List<String> goin = await NetServerController().getChatUser(Chats.nowChat);
    
    if (goin.isNotEmpty && goin != " ") {
      print('Return Login $goin');
      
      if (goin[0] == "true") {
        for (int i = 1; i < goin.length; i += 2) {
          int uid = int.parse(goin[i]);
          RSAPrivateKey privateKey = CryptController.decodePrivateKey(
            CryptController.decryptPrivateKey(goin[i + 1], Chats.nowChat, Chats.getChatPassword(Chats.nowChat))
          );

          Chats.addUserInChat(
            Chats.nowChat,
            Subuser(
              id: uid,
              userName: "",
              publicKey: null,
              privateKey: privateKey
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

  void sendMessage(String message){
    Subuser? subuser = Chats.getNowSubuser();
    if(subuser != null && subuser.publicKey != null){
      NetServerController().sendMessage("+", message, Chats.nowChat, subuser.id, subuser.publicKey!);
      return;
    }
    print("subuser is not available");
    return;
  }

  void deleteMessage(int id){
    Subuser? subuser = Chats.getNowSubuser();
    if(subuser != null && subuser.publicKey != null){
      NetServerController().sendMessage("-", id.toString(), Chats.nowChat, subuser.id, subuser.publicKey!);
      return;
    }
    print("subuser is not available");
    return;
  }

  String getNameGroup(){
    return Chats.getValue().chats.firstWhere(
      (chat) => chat.chatId == Chats.nowChat
      ).chatName;
  }

  int getCountUsers(){
    return Chats.getValue().chats.firstWhere(
      (chat) => chat.chatId == Chats.nowChat
      ).subusers.length;
  }
}