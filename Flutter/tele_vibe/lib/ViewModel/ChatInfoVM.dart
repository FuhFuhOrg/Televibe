import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/localDataSaveController.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/GettedData/pseudoChatApi.dart';

class ChatInfoVM {
  Future<bool> deleteNowGroup(BuildContext context) async {
    if (PseudoChatApi.isEnabled) {
      Chats.removeChat(Chats.nowChat);
      return true;
    }

    bool isDeleted = await NetServerController().deleteGroup(Chats.nowChat);

    if (isDeleted) {
      Chats.removeChat(Chats.nowChat);
      LocalDataSave.saveChatsData();
    }

    return isDeleted;
  }

  List<Subuser> getSubusers() {
    return Chats.getNowChat()?.subusers ?? [];
  }

  String getNameGroup() {
    return Chats.getNowChat()?.chatName ?? 'Chat details';
  }

  int getCountUsers() {
    return Chats.getNowChat()?.subusers.length ?? 0;
  }

  String getChatId() {
    return Chats.nowChat;
  }
}
