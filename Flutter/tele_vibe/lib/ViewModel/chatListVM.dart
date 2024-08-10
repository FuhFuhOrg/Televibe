import 'dart:async';

import 'package:tele_vibe/Data/chats.dart';


class ChatListVM {
  late StreamSubscription<int> _chatsSubscription;

   LoginVM() {
    _chatsSubscription = Chats.onValueChanged.listen((value) {
      _handleChatsValueChanged(value);
    });
  }

  void dispose() {
    _chatsSubscription.cancel();
  }

  void _handleChatsValueChanged(int value) {
    // Здесь вы можете выполнять действия при изменении переменной value
    print('Chats value changed: $value');
  }
}