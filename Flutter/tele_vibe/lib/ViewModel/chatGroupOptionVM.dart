


import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart';
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
          Chats.addChat(ChatData(chatName: name, chatId: goin[1], password: password, nowQueueId: -1, chatIp: serverId));
          MessageHandler.showAlertDialog(context, 'Добавлен чат ${goin[1]}');
        }
        else{
          MessageHandler.showAlertDialog(context, '${goin.join(" ")}');
        }
      }
    });
  }

  void addChat(){

  }
  
  void dispose() {
    
  }
}