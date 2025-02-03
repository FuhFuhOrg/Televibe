

import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart';
import 'package:tele_vibe/GettedData/localDataSaveController.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';

class ChatInfoVM 
{
  Future<bool> deleteNowGroup(BuildContext context) async 
  {
    bool isDeleted = await NetServerController().deleteGroup(Chats.nowChat);

    if (isDeleted) 
    {
      Chats.removeChat(Chats.nowChat);
      LocalDataSave.saveChatsData();
    }

    return isDeleted;
  }
}
