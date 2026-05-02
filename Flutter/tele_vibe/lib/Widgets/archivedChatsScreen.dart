import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/pseudoChatApi.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/Widgets/UnderWidgets/telegramAvatar.dart';
import 'package:tele_vibe/Widgets/chatList.dart';

class ArchivedChatsScreen extends StatefulWidget {
  const ArchivedChatsScreen({super.key});

  @override
  State<ArchivedChatsScreen> createState() => _ArchivedChatsScreenState();
}

class _ArchivedChatsScreenState extends State<ArchivedChatsScreen> {
  StreamSubscription<ChatCollection>? _subscription;
  ChatCollection _collection = Chats.getValue();

  @override
  void initState() {
    super.initState();
    _subscription = Chats.onValueChanged.listen((value) {
      if (!mounted) return;
      setState(() => _collection = value);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final archived = _collection.chats
        .where((chat) => PseudoChatApi.isChatArchived(chat.chatId))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17212B),
        title: Text(l10n.archivedChatsTitle,
            style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: archived.isEmpty
          ? const _EmptyArchiveState()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF17212B),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF243447)),
                  ),
                  child: Text(
                    l10n.archivedChatsDescription(count: archived.length),
                    style: const TextStyle(
                      color: Color(0xFF7F91A4),
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ...archived.map(
                  (chat) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF17212B),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF243447)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      leading: TelegramAvatar(
                        title: chat.chatName,
                        imageUrl: chat.avatarUrl,
                        radius: 24,
                        isGroup: chat.isGroup,
                      ),
                      title: Text(
                        chat.chatName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        chat.getLastMessage(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFF7F91A4)),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          PseudoChatApi.toggleArchived(chat.chatId);
                          setState(() {});
                        },
                        icon: const Icon(Icons.unarchive_outlined,
                            color: Color(0xFF2AABEE)),
                      ),
                      onTap: () {
                        Chats.nowChat = chat.chatId;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatListPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _EmptyArchiveState extends StatelessWidget {
  const _EmptyArchiveState();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.archive_outlined,
                color: Color(0xFF7F91A4), size: 42),
            const SizedBox(height: 12),
            Text(
              l10n.archiveIsEmpty,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.archiveEmptyDescription,
              style: const TextStyle(
                color: Color(0xFF7F91A4),
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
