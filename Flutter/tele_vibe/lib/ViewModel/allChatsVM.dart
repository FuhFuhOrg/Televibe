import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/Widgets/chatList.dart';


class AllChatsVM {
  late StreamSubscription<int> _chatsSubscription;

   LoginVM() {
    _chatsSubscription = Chats.onValueChanged.listen((value) {
      _handleChatsValueChanged(value);
    });
  }

  void dispose() {
    _chatsSubscription.cancel();
  }

  void navigateToChatList(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatListPage()),
    );
  }

  void _handleChatsValueChanged(int value) {
    // Здесь вы можете выполнять действия при изменении переменной value
    print('Chats value changed: $value');
  }
}