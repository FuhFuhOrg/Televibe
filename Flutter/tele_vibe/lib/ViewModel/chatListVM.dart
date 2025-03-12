


import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:tele_vibe/Data/chats.dart';
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
        command = command.substring(2).trim(); // Удаляем первые два символа и лишние пробелы
        List<String> parts = command.split(' ');
        String timePart = parts[0]; // Время из команды
        String messageText = command.substring(timePart.length).trim(); // Текст без времени

        messages.add({
          'text': messageText,
          'isMe': commandUserCode.$2 == cd.yourUserId, // Оптимизированная запись
          'userName': commandUserCode.$2, // Можно добавить логику определения пользователя
          'time': timePart, // Можно добавить актуальное время
          'id': k,
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
      for(String item in goin){
        print('$item');
      }
      
      if (goin[0] == "true") {
        for (int i = 1; i < goin.length; i += 4) {
          int uid = int.parse(goin[i]);
          String item = CryptController.decryptPrivateKey(goin[i + 1], Chats.nowChat, Chats.getChatPassword(Chats.nowChat));
          RSAPrivateKey privateKey = CryptController.decodePrivateKey(item);
          String name = goin[i + 2];
          Image image = Subuser.imageFromBase64(goin[i + 3]);

          Chats.addUserInChat(
            Chats.nowChat,
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

  Future<bool> sendMessage(String message) async {
    Subuser? subuser = Chats.getNowSubuser();
    if(subuser != null && subuser.publicKey != null){
      DateTime now = DateTime.now();
      String formattedTime = 
          '${now.year}:${now.month.toString().padLeft(2, '0')}:${now.day.toString().padLeft(2, '0')}:${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
      NetServerController().sendMessage("+", '$formattedTime $message', Chats.nowChat, subuser.id, subuser.publicKey!);
      return true;
    }
    print("subuser is not available");
    return false;
  }

  Future<void> changeMessage(String message, int id) async {
    Subuser? subuser = Chats.getNowSubuser();
    if(subuser != null && subuser.publicKey != null){
      NetServerController().sendMessage("* $id", message, Chats.nowChat, subuser.id, subuser.publicKey!);
      return;
    }
    print("subuser is not available");
    return;
  }

  Future<void> deleteMessage(int id) async {
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