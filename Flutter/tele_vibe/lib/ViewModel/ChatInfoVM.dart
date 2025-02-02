

import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart';
import 'package:tele_vibe/GettedData/localDataSaveController.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';

class ChatInfoVM 
{
  void deleteNowGroup(BuildContext context) async {
  bool isDeleted = await NetServerController().deleteGroup(Chats.nowChat);

// Тут еще проверки можно
  if (isDeleted) {
    Chats.removeChat(Chats.nowChat);

    MessageHandler.showAlertDialog(context, 'Чат удалён');
    
    LocalDataSave.saveChatsData();
  } else {
    MessageHandler.showAlertDialog(context, 'Не удалось удалить чат');
  }
}
}