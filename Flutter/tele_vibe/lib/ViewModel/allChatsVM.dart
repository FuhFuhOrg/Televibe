
import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/Widgets/chatList.dart';

class AllChatsVM {
  void clearChatHistory() {
    // Логика очистки истории
  }

  void leaveGroup() {
    // Логика выхода из группы
  }

  void dispose() {
    
  }

  void navigateToChat(BuildContext context, String newChat){
    Chats.nowChat = newChat;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatListPage()),
    );
  }
}