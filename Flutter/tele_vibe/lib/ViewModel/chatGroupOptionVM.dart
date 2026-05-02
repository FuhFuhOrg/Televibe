import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/Data/user.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart';
import 'package:tele_vibe/GettedData/cryptController.dart';
import 'package:tele_vibe/GettedData/localDataSaveController.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/GettedData/pseudoChatApi.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';

class ChatGroupOptionVM {
  void createChat(BuildContext context, String nameId, String password,
      String serverId, bool isChat) {
    final l10n = context.l10n;

    if (PseudoChatApi.isEnabled) {
      PseudoChatApi.createChat(name: nameId, isGroup: isChat).then((_) {
        if (!context.mounted) return;
        MessageHandler.showAlertDialog(context, l10n.chatCreated);
        Navigator.pop(context);
      });
      return;
    }

    if (serverId == "") {
      awaitCreateChat(context, nameId, password, serverId, isChat);
    } else {
      // Написать функционал подключения к локальной машине пользователя как в тимспик
    }
  }

  void awaitCreateChat(BuildContext context, String name, String password,
      String serverId, bool isChat) {
    final l10n = context.l10n;

    NetServerController().createNewChat(password, isChat).then((goin) {
      if (goin.isNotEmpty && goin.any((item) => item.trim().isNotEmpty)) {
        debugPrint('Return Login $goin');
        if (goin[0] == "true") {
          if (!context.mounted) return;
          MessageHandler.showAlertDialog(
            context,
            l10n.chatCreatedWithId(chatId: goin[1]),
          );
          enterInChat(context, name, goin[1], password, serverId);
        } else {
          if (!context.mounted) return;
          MessageHandler.showAlertDialog(context, goin.join(" "));
        }
      }
    });
  }

  void enterInChat(BuildContext context, String name, String chatId,
      String password, String serverId) {
    final l10n = context.l10n;

    if (PseudoChatApi.isEnabled) {
      PseudoChatApi.createChat(
        name: name.isEmpty ? 'Chat $chatId' : name,
        isGroup: false,
      ).then((_) {
        if (!context.mounted) return;
        MessageHandler.showAlertDialog(context, l10n.chatAdded);
        Navigator.pop(context);
      });
      return;
    }

    (RSAPublicKey pub, RSAPrivateKey priv) keyPair =
        CryptController.generateRSAKeyPair();

    if (Anon.anonIdGet != null && Anon.anonPasswordGet != null) {
      NetServerController()
          .addUserToChat(keyPair.$1, keyPair.$2, chatId, password,
              Anon.anonIdGet, Anon.anonPasswordGet, Anon.username, Anon.image)
          .then((goin) {
        if (goin.isNotEmpty && goin.any((item) => item.trim().isNotEmpty)) {
          debugPrint('Return Login $goin');
          if (goin[0] == "true") {
            List<Subuser> newChatUsers = [];
            newChatUsers.add(Subuser(
              id: int.parse(goin[1]),
              userName: Anon.username,
              publicKey: keyPair.$1,
              privateKey: keyPair.$2,
              image: Anon.image, // Используем Image.asset
            ));
            Chats.addChat(ChatData(
                chatName: name,
                chatId: chatId,
                password: password,
                nowQueueId: -1,
                chatIp: serverId,
                yourUserId: int.parse(goin[1]),
                subusers: newChatUsers));

            if (!context.mounted) return;
            MessageHandler.showAlertDialog(
              context,
              l10n.addedUserToChat(userId: goin[1]),
            );

            LocalDataSave.saveChatsData();
          } else {
            if (!context.mounted) return;
            MessageHandler.showAlertDialog(context, goin.join(" "));
          }
        }
      });
    }
  }

  void dispose() {}
}
