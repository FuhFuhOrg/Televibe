import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/pseudoChatApi.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/Widgets/UnderWidgets/telegramAvatar.dart';
import 'package:tele_vibe/Widgets/chatList.dart';
import 'package:tele_vibe/Widgets/profileScreenOther.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final contacts = PseudoChatApi.contacts()
        .where(
          (contact) =>
              contact.name
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              contact.username
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()),
        )
        .toList();
    final onlineCount =
        PseudoChatApi.contacts().where((item) => item.isOnline).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17212B),
        title: Text(l10n.contactsTitle,
            style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF17212B),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF243447)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.peopleAndTeamsTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.contactsSummary(
                    total: PseudoChatApi.contacts().length,
                    online: onlineCount,
                  ),
                  style: const TextStyle(
                    color: Color(0xFF7F91A4),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  cursorColor: const Color(0xFF2AABEE),
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: l10n.searchByNameOrUsername,
                    hintStyle: const TextStyle(color: Color(0xFF7F91A4)),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Color(0xFF7F91A4)),
                    filled: true,
                    fillColor: const Color(0xFF0E1621),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF243447)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF2AABEE)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (contacts.isEmpty)
            const _EmptyContactsState()
          else
            ...contacts.map(
              (contact) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF17212B),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF243447)),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  leading: Stack(
                    children: [
                      TelegramAvatar(
                        title: contact.name,
                        imageUrl: contact.avatarUrl,
                        radius: 25,
                      ),
                      if (contact.isOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFF46D181),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF17212B),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    contact.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.username,
                        style: const TextStyle(color: Color(0xFF9FB0C0)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        contact.status,
                        style: TextStyle(
                          color: contact.isOnline
                              ? const Color(0xFF46D181)
                              : const Color(0xFF7F91A4),
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () => _openChat(contact),
                    icon: const Icon(Icons.chat_bubble_outline_rounded,
                        color: Color(0xFF2AABEE)),
                  ),
                  onTap: () => _openChat(contact),
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreenOther(
                          nickname: contact.name,
                          userID: contact.id,
                          image: null,
                        ),
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

  void _openChat(PseudoContact contact) {
    final chat = PseudoChatApi.openOrCreateDirectChat(contact);
    Chats.nowChat = chat.chatId;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatListPage()),
    );
  }
}

class _EmptyContactsState extends StatelessWidget {
  const _EmptyContactsState();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF17212B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF243447)),
      ),
      child: Column(
        children: [
          Icon(Icons.group_outlined, color: Color(0xFF7F91A4), size: 36),
          SizedBox(height: 12),
          Text(
            l10n.noContactsFound,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            l10n.tryAnotherContactQuery,
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF7F91A4), height: 1.35),
          ),
        ],
      ),
    );
  }
}
