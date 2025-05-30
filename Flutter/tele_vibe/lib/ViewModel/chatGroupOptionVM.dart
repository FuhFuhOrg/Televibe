import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/Data/user.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart';
import 'package:tele_vibe/GettedData/cryptController.dart';
import 'package:tele_vibe/GettedData/localDataSaveController.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';

class ChatGroupOptionVM
{
  void createChat(BuildContext context, 
    String nameId, String password, String serverId, bool isChat)
  {
    if(serverId == ""){
      awaitCreateChat(context, nameId, password, serverId, isChat);
    }else{
      // Написать функционал подключения к локальной машине пользователя как в тимспик
    }
  }

  void awaitCreateChat(BuildContext context, 
    String name, String password, String serverId, bool isChat)
  {
    NetServerController().createNewChat(password, isChat).then((goin) {
      if (goin != " " && goin != "") {
        print('Return Login ${goin}');
        if(goin[0] == "true") {
          MessageHandler.showAlertDialog(context, 'Создан чат: ${goin[1]}');
          enterInChat(context, name, goin[1], password, serverId);
        }
        else{
          MessageHandler.showAlertDialog(context, '${goin.join(" ")}');
        }
      }
    });
  }

  void enterInChat(BuildContext context, 
    String name, String chatId, String password, String serverId) {

    (RSAPublicKey pub, RSAPrivateKey priv) _keyPair = CryptController.generateRSAKeyPair();

    if (Anon.anonIdGet != null && Anon.anonPasswordGet != null) {
      NetServerController()
          .addUserToChat(_keyPair.$1, _keyPair.$2, chatId, password, Anon.anonIdGet, Anon.anonPasswordGet, Anon.username, Anon.image)
          .then((goin) {
        if (goin != " " && goin != "") {
          print('Return Login ${goin}');
          if (goin[0] == "true") {
            List<Subuser> newChatUsers = [];
            newChatUsers.add(Subuser(
              id: int.parse(goin[1]),
              userName: Anon.username,
              publicKey: _keyPair.$1,
              privateKey: _keyPair.$2,
              image: Anon.image, // Используем Image.asset
            ));
            Chats.addChat(ChatData(chatName: name, chatId: chatId, password: password, nowQueueId: -1, chatIp: serverId, yourUserId: int.parse(goin[1]), subusers: newChatUsers));

            MessageHandler.showAlertDialog(context, 'Добавлен пользователь в чат: ${goin[1]}');
            
            LocalDataSave.saveChatsData();
          } else {
            MessageHandler.showAlertDialog(context, '${goin.join(" ")}');
          }
        }
      });
    }
  }
  
  void dispose() {
    
  }
}