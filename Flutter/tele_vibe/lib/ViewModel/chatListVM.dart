import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart';
import 'package:tele_vibe/GettedData/cryptController.dart';
import 'package:tele_vibe/GettedData/localDataSaveController.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';

class ChatListVM {

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
      
      // Если это изображение
      if (message.startsWith('<img>') && message.endsWith('</img>')) {
        // Извлекаем base64 строку
        String base64Str = message.substring(5, message.length - 6);
        
        // Шифруем маркеры начала и конца
        String encryptedStart = CryptController.encryptRSA("START", subuser.publicKey!);
        String encryptedEnd = CryptController.encryptRSA("END", subuser.publicKey!);
        
        // Формируем сообщение: зашифрованный старт | base64 изображения | зашифрованный конец
        String fullMessage = '$encryptedStart|$base64Str|$encryptedEnd';
        
        // Отправляем сообщение
        String result = await NetServerController().sendMessage("+", '$formattedTime <img>$fullMessage</img>', Chats.nowChat, subuser.id, subuser.publicKey!);
        return result == "true";
      } else {
        // Обычное текстовое сообщение
        String result = await NetServerController().sendMessage("+", '$formattedTime $message', Chats.nowChat, subuser.id, subuser.publicKey!);
        return result == "true";
      }
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