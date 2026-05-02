import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/cryptController.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/GettedData/pseudoChatApi.dart';

class ChatListVM {
  Future<bool> sendMessage(String message) async {
    if (PseudoChatApi.isEnabled) {
      return PseudoChatApi.sendMessage(message);
    }

    Subuser? subuser = Chats.getNowSubuser();
    if (subuser != null && subuser.publicKey != null) {
      DateTime now = DateTime.now();
      String formattedTime =
          '${now.year}:${now.month.toString().padLeft(2, '0')}:${now.day.toString().padLeft(2, '0')}:${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      // Если это изображение
      if (message.startsWith('<img>') && message.endsWith('</img>')) {
        // Извлекаем base64 строку
        String base64Str = message.substring(5, message.length - 6);

        // Шифруем маркеры начала и конца
        String encryptedStart =
            CryptController.encryptRSA("START", subuser.publicKey!);
        String encryptedEnd =
            CryptController.encryptRSA("END", subuser.publicKey!);

        // Формируем сообщение: зашифрованный старт | base64 изображения | зашифрованный конец
        String fullMessage = '$encryptedStart|$base64Str|$encryptedEnd';

        // Отправляем сообщение
        String result = await NetServerController().sendMessage(
            "+",
            '$formattedTime <img>$fullMessage</img>',
            Chats.nowChat,
            subuser.id,
            subuser.publicKey!);
        return result == "true";
      } else {
        // Обычное текстовое сообщение
        String result = await NetServerController().sendMessage(
            "+",
            '$formattedTime $message',
            Chats.nowChat,
            subuser.id,
            subuser.publicKey!);
        return result == "true";
      }
    }
    debugPrint("subuser is not available");
    return false;
  }

  Future<void> changeMessage(String message, int id) async {
    if (PseudoChatApi.isEnabled) {
      await PseudoChatApi.editMessage(id, message);
      return;
    }

    Subuser? subuser = Chats.getNowSubuser();
    if (subuser != null && subuser.publicKey != null) {
      NetServerController().sendMessage(
          "* $id", message, Chats.nowChat, subuser.id, subuser.publicKey!);
      return;
    }
    debugPrint("subuser is not available");
    return;
  }

  Future<void> deleteMessage(int id) async {
    if (PseudoChatApi.isEnabled) {
      await PseudoChatApi.deleteMessage(id);
      return;
    }

    Subuser? subuser = Chats.getNowSubuser();
    if (subuser != null && subuser.publicKey != null) {
      NetServerController().sendMessage(
          "-", id.toString(), Chats.nowChat, subuser.id, subuser.publicKey!);
      return;
    }
    debugPrint("subuser is not available");
    return;
  }

  String getNameGroup() {
    return Chats.getNowChat()?.chatName ?? 'Chat';
  }

  int getCountUsers() {
    return Chats.getNowChat()?.subusers.length ?? 0;
  }
}
