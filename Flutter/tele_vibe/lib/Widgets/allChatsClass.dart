import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/Data/user.dart';
import 'package:tele_vibe/GettedData/pseudoChatApi.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/ViewModel/allChatsVM.dart';
import 'package:tele_vibe/Widgets/archivedChatsScreen.dart';
import 'package:tele_vibe/Widgets/callsScreen.dart';
import 'package:tele_vibe/Widgets/profileScreen.dart';
import 'package:tele_vibe/Widgets/settings.dart';
import 'package:tele_vibe/Widgets/chatGroupOptionsPage.dart';
import 'package:tele_vibe/Widgets/channelsScreen.dart';
import 'package:tele_vibe/Widgets/contactsScreen.dart';
import 'package:tele_vibe/Widgets/nearbyPeopleScreen.dart';
import 'package:tele_vibe/Widgets/savedMessagesScreen.dart';
import 'package:tele_vibe/Widgets/searchScreen.dart';
import 'package:tele_vibe/Widgets/storiesViewerScreen.dart';
import 'package:tele_vibe/Widgets/UnderWidgets/telegramAvatar.dart';

class AllChatsPage extends StatefulWidget {
  const AllChatsPage({super.key});

  @override
  State<AllChatsPage> createState() => _AllChatsClassState();
}

class _AllChatsClassState extends State<AllChatsPage> {
  final AllChatsVM _allChatsVM = AllChatsVM();
  StreamSubscription<ChatCollection>? subscriptionChats;
  ChatCollection chatsData = Chats.getValue();
  _ChatsFolder _selectedFolder = _ChatsFolder.all;

  void refresh_() {
    setState(() => chatsData = Chats.getValue());
  }

  List<ChatData> get _activeChats => chatsData.chats
      .where((chat) => !PseudoChatApi.isChatArchived(chat.chatId))
      .toList();

  List<ChatData> get _archivedChats => chatsData.chats
      .where((chat) => PseudoChatApi.isChatArchived(chat.chatId))
      .toList();

  List<ChatData> _visibleChats() {
    final source =
        _selectedFolder == _ChatsFolder.archive ? _archivedChats : _activeChats;

    switch (_selectedFolder) {
      case _ChatsFolder.all:
        return source;
      case _ChatsFolder.direct:
        return source.where((chat) => !chat.isGroup).toList();
      case _ChatsFolder.groups:
        return source.where((chat) => chat.isGroup).toList();
      case _ChatsFolder.unread:
        return source.where((chat) => chat.unreadCount > 0).toList();
      case _ChatsFolder.archive:
        return source;
    }
  }

  @override
  void initState() {
    super.initState();
    chatsData = Chats.getValue();
    subscriptionChats = Chats.onValueChanged.listen((newValue) {
      if (!mounted) return;
      setState(() => chatsData = newValue);
    });
  }

  @override
  void dispose() {
    subscriptionChats?.cancel();
    _allChatsVM.dispose();
    super.dispose();
  }

  // Строим список чатов как отдельный метод
  Widget _buildChatList() {
    final l10n = context.l10n;

    final chats = List<ChatData>.from(_visibleChats())
      ..sort((a, b) {
        if (a.isPinned == b.isPinned) return 0;
        return a.isPinned ? -1 : 1;
      });

    if (chats.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.forum_outlined,
                color: Color(0xFF7F91A4),
                size: 42,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.nothingHereYet,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                _emptyFolderMessage(context),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 6, bottom: 92),
      itemCount: chats.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        indent: 82,
        color: Color(0xFF1F2C3A),
      ),
      itemBuilder: (BuildContext context, int index) {
        final chat = chats[index];
        return _ChatTile(
          chat: chat,
          onTap: () => _allChatsVM.navigateToChat(context, chat.chatId),
          onLongPress: () => _showParticipantOptions(context, chat),
        );
      },
    );
  }

  String _emptyFolderMessage(BuildContext context) {
    final l10n = context.l10n;

    switch (_selectedFolder) {
      case _ChatsFolder.direct:
        return l10n.noDirectChatsYet;
      case _ChatsFolder.groups:
        return l10n.noGroupsYet;
      case _ChatsFolder.unread:
        return l10n.noUnreadChatsYet;
      case _ChatsFolder.archive:
        return l10n.archiveFolderEmpty;
      case _ChatsFolder.all:
        return l10n.startDirectChatPrompt;
    }
  }

  void _showParticipantOptions(BuildContext context, ChatData chat) {
    final l10n = context.l10n;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17212B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: TelegramAvatar(
                  title: chat.chatName,
                  imageUrl: chat.avatarUrl,
                  isGroup: chat.isGroup,
                ),
                title: Text(chat.chatName,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                  chat.isGroup
                      ? l10n.memberCount(count: chat.subusers.length)
                      : l10n.directChat,
                  style: const TextStyle(color: Color(0xFF7F91A4)),
                ),
              ),
              ListTile(
                leading: Icon(
                  chat.isPinned
                      ? Icons.push_pin_outlined
                      : Icons.push_pin_rounded,
                  color: const Color(0xFF7F91A4),
                ),
                title: Text(
                  chat.isPinned ? l10n.unpinChat : l10n.pinChat,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  chat.isPinned = !chat.isPinned;
                  Chats.setValue(Chats.getValue());
                  refresh_();
                },
              ),
              ListTile(
                leading: Icon(
                  PseudoChatApi.isChatArchived(chat.chatId)
                      ? Icons.unarchive_outlined
                      : Icons.archive_outlined,
                  color: const Color(0xFF7F91A4),
                ),
                title: Text(
                  PseudoChatApi.isChatArchived(chat.chatId)
                      ? l10n.unarchiveChat
                      : l10n.archiveChat,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  PseudoChatApi.toggleArchived(chat.chatId);
                  refresh_();
                },
              ),
              if (chat.isGroup)
                ListTile(
                  leading: const Icon(Icons.logout_rounded,
                      color: Color(0xFF7F91A4)),
                  title: Text(
                    l10n.leaveGroup,
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _allChatsVM.leaveGroup(chat.chatId);
                    refresh_();
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFFE57373)),
                title: Text(l10n.deleteChat,
                    style: const TextStyle(color: Color(0xFFE57373))),
                onTap: () {
                  Navigator.pop(context);
                  _allChatsVM.deleteChat(chat.chatId);
                  refresh_();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17212B),
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: const Row(
          children: [
            Text(
              'Televibe',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStoriesStrip(),
          _buildFolderBar(),
          Expanded(child: _buildChatList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ChatGroupOptionsPage()),
          );

          await Future.delayed(const Duration(milliseconds: 200));
          if (!mounted) return;
          refresh_();
        },
        backgroundColor: const Color(0xFF2AABEE),
        child: const Icon(
          Icons.edit_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildStoriesStrip() {
    final stories = PseudoChatApi.stories();

    return SizedBox(
      height: 112,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final story = stories[index];
          return _StoryBubble(
            story: story,
            viewed: PseudoChatApi.isStoryViewed(story.id),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      StoriesViewerScreen(initialIndex: index),
                ),
              );
              if (!mounted) return;
              setState(() {});
            },
          );
        },
      ),
    );
  }

  Widget _buildFolderBar() {
    final l10n = context.l10n;

    return SizedBox(
      height: 52,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 2, 14, 8),
        scrollDirection: Axis.horizontal,
        children: [
          _FolderChip(
            label: l10n.allFilterLabel,
            selected: _selectedFolder == _ChatsFolder.all,
            onTap: () => setState(() => _selectedFolder = _ChatsFolder.all),
          ),
          _FolderChip(
            label: l10n.directFilterLabel,
            selected: _selectedFolder == _ChatsFolder.direct,
            onTap: () => setState(() => _selectedFolder = _ChatsFolder.direct),
          ),
          _FolderChip(
            label: l10n.groupsFilterLabel,
            selected: _selectedFolder == _ChatsFolder.groups,
            onTap: () => setState(() => _selectedFolder = _ChatsFolder.groups),
          ),
          _FolderChip(
            label: l10n.unreadFilterLabel,
            selected: _selectedFolder == _ChatsFolder.unread,
            onTap: () => setState(() => _selectedFolder = _ChatsFolder.unread),
          ),
          _FolderChip(
            label: l10n.archiveFilterLabel,
            selected: _selectedFolder == _ChatsFolder.archive,
            onTap: () => setState(() => _selectedFolder = _ChatsFolder.archive),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    final l10n = context.l10n;
    final username = Anon.username.isEmpty ? 'You' : Anon.username;

    return Drawer(
      backgroundColor: const Color(0xFF17212B),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            CircleAvatar(
              radius: 34,
              backgroundImage: Anon.image.image,
            ),
            const SizedBox(height: 10),
            Text(username,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            Text(
              l10n.personalAccount,
              style: TextStyle(color: Color(0xFF7F91A4)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D2A38),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  l10n.chatsReadyToOpen(count: chatsData.chats.length),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Divider(color: Color(0xFF243447), height: 1),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded,
                  color: Color(0xFF7F91A4)),
              title: Text(l10n.profileTitle,
                  style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(
                      nickname: 'You',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.archive_outlined, color: Color(0xFF7F91A4)),
              title: Text(l10n.archivedChatsTitle,
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArchivedChatsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.call_outlined, color: Color(0xFF7F91A4)),
              title: Text(l10n.callsTitle,
                  style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CallsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outline_rounded,
                  color: Color(0xFF7F91A4)),
              title: Text(l10n.contactsTitle,
                  style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_rounded,
                  color: Color(0xFF7F91A4)),
              title: const Text('Saved Messages',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SavedMessagesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.campaign_outlined,
                  color: Color(0xFF7F91A4)),
              title: const Text('Channels',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChannelsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_alt_outlined,
                  color: Color(0xFF7F91A4)),
              title: const Text('Find People',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NearbyPeopleScreen()),
                );
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.settings_outlined, color: Color(0xFF7F91A4)),
              title: Text(l10n.settingsTitle,
                  style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FolderChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FolderChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2AABEE) : const Color(0xFF17212B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color:
                  selected ? const Color(0xFF2AABEE) : const Color(0xFF243447),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _StoryBubble extends StatelessWidget {
  final PseudoStory story;
  final bool viewed;
  final VoidCallback onTap;

  const _StoryBubble({
    required this.story,
    required this.viewed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: 78,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: viewed
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFF2AABEE), Color(0xFF7AD7FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                border: viewed
                    ? Border.all(color: const Color(0xFF243447), width: 2)
                    : null,
              ),
              child: TelegramAvatar(
                title: story.title,
                imageUrl: story.avatarUrl,
                radius: 27,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              story.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final ChatData chat;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ChatTile({
    required this.chat,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            TelegramAvatar(
              title: chat.chatName,
              imageUrl: chat.avatarUrl,
              radius: 29,
              isGroup: chat.isGroup,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.chatName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (chat.isPinned)
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(Icons.push_pin_rounded,
                              size: 15, color: Color(0xFF7F91A4)),
                        ),
                      Text(
                        chat.getLastMessageTime(),
                        style: TextStyle(
                          color: chat.unreadCount > 0
                              ? const Color(0xFF2AABEE)
                              : const Color(0xFF7F91A4),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.getLastMessage(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF7F91A4),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (chat.unreadCount > 0)
                        Container(
                          constraints: const BoxConstraints(minWidth: 22),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2AABEE),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ChatsFolder {
  all,
  direct,
  groups,
  unread,
  archive,
}
