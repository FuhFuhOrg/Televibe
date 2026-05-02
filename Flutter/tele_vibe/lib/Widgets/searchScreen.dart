import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/Widgets/chatList.dart';
import 'package:tele_vibe/Widgets/UnderWidgets/telegramAvatar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ChatData> _filteredChats = [];
  ChatCollection chatsData = ChatCollection();

  @override
  void initState() {
    super.initState();
    chatsData = Chats.getValue();
    _filteredChats = List.from(chatsData.chats);
    _searchController.addListener(() {
      _searchChats(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchChats(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredChats = chatsData.chats;
      } else {
        _filteredChats = chatsData.chats
            .where((chat) =>
                chat.chatName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF17212B),
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          cursorColor: Colors.white,
          controller: _searchController,
          decoration: InputDecoration(
            hintText: l10n.searchChatsHint,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _searchChats,
        ),
      ),
      backgroundColor: const Color(0xFF0E1621),
      body: _filteredChats.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.only(top: 8, bottom: 18),
              itemCount: _filteredChats.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 82,
                color: Color(0xFF1F2C3A),
              ),
              itemBuilder: (BuildContext context, int index) {
                final chat = _filteredChats[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  onTap: () {
                    Chats.nowChat = chat.chatId;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatListPage()),
                    );
                  },
                  leading: TelegramAvatar(
                    title: chat.chatName,
                    imageUrl: chat.avatarUrl,
                    radius: 26,
                    isGroup: chat.isGroup,
                  ),
                  tileColor: const Color(0xFF0E1621),
                  textColor: Colors.white,
                  title: Text(chat.chatName,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                    chat.getLastMessage(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF7F91A4)),
                  ),
                  trailing: Text(
                    chat.getLastMessageTime(),
                    style: const TextStyle(color: Color(0xFF7F91A4)),
                  ),
                );
              },
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off_rounded,
                        color: Color(0xFF7F91A4), size: 42),
                    const SizedBox(height: 12),
                    Text(
                      l10n.noChatsFound,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _searchController.text.isEmpty
                          ? l10n.startTypingToBrowseConversations
                          : l10n.tryAnotherNameOrCreateChat,
                      style: const TextStyle(
                        color: Color(0xFF7F91A4),
                        height: 1.35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
