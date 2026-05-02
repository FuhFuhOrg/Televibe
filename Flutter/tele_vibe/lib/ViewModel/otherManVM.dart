import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';

// Вот здесь поменяй, где ты держишь этот чертов юзер айди, потому что я в душе не чаю, какой из них именно этого пользователя
class OtherManVM {
  String getUsername(int? userID) {
    final chat = Chats.getNowChat();
    if (chat == null || userID == null) return 'Unknown user';

    for (final user in chat.subusers) {
      if (user.id == userID) return user.userName;
    }
    return 'Unknown user';
  }

  Image? getImage(int? userID) {
    final chat = Chats.getNowChat();
    if (chat == null || userID == null) return null;

    for (final user in chat.subusers) {
      if (user.id == userID) return user.image;
    }
    return null;
  }

  String getInfoAboutMe(int? userID) {
    return "Nyaaaaaaaaaaa";
  }
}
