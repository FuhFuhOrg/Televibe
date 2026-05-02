import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/ViewModel/ChatInfoVM.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart' as message_handler;
import 'package:tele_vibe/GettedData/pseudoChatApi.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/Widgets/allChatsClass.dart';
import 'package:tele_vibe/Widgets/UnderWidgets/telegramAvatar.dart';

import 'addParticipantScreen.dart';
import 'profileScreen.dart'; // Экран профиля
import 'profileScreenOther.dart'; // Экран профиля
import 'renameTextField.dart';

class ChatInfo extends StatefulWidget {
  const ChatInfo({super.key, required this.initialGroupName});

  final String initialGroupName;

  @override
  State<ChatInfo> createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo> {
  final ChatInfoVM _chatListVM = ChatInfoVM();
  late String _groupName;
  late int kUsers;
  late String _chatId;
  ChatData? _chat;
  int _contentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Инициализация поля _groupName значением из конструктора
    _groupName = _chatListVM.getNameGroup();
    kUsers = _chatListVM.getCountUsers();
    _chatId = _chatListVM.getChatId();
    _chat = Chats.getNowChat();
  }

  // Метод для перехода на экран изменения текста
  void _navigateToEditScreen(BuildContext context, String title,
      String currentText, Function(String) onSave) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RenameTextField(title: title, currentText: currentText),
      ),
    );
    if (!context.mounted) return;
    if (result != null) {
      onSave(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isGroup = _chat?.isGroup ?? false;
    final media = PseudoChatApi.mediaForChat(_chat);
    final files = PseudoChatApi.filesForChat(_chat);
    final links = PseudoChatApi.linksForChat(_chat);

    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: const Color(0xFF17212B),
            expandedHeight: MediaQuery.of(context).size.height * 3 / 7,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1C2B3A), Color(0xFF0E1621)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Center(
                    child: TelegramAvatar(
                      title: _groupName,
                      imageUrl: _chat?.avatarUrl,
                      radius: 58,
                      isGroup: _chat?.isGroup ?? true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            _groupName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            isGroup
                                ? l10n.memberCount(count: kUsers)
                                : l10n.directConversation,
                            style: const TextStyle(
                              color: Color(0xFF7F91A4),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              collapseMode: CollapseMode.parallax,
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  _navigateToEditScreen(context, l10n.chatNameField, _groupName,
                      (newName) {
                    setState(() {
                      _groupName = newName;
                    });
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  _showProfileOptions(context);
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                if (isGroup)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AddParticipantScreen()),
                        );
                      },
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2AABEE),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      label: Text(l10n.addParticipants),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 52.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _chatId));
                      message_handler.MessageHandler.showAlertDialog(
                          context, l10n.chatIdCopied);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF222222),
                    ),
                    child: Text(l10n.copyChatId,
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF17212B),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF243447)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.sharedContentTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.sharedContentDescription,
                          style: TextStyle(
                            color: Color(0xFF7F91A4),
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _ContentTabButton(
                                label: l10n.mediaTab,
                                selected: _contentTabIndex == 0,
                                onTap: () {
                                  setState(() => _contentTabIndex = 0);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _ContentTabButton(
                                label: l10n.filesTab,
                                selected: _contentTabIndex == 1,
                                onTap: () {
                                  setState(() => _contentTabIndex = 1);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _ContentTabButton(
                                label: l10n.linksTab,
                                selected: _contentTabIndex == 2,
                                onTap: () {
                                  setState(() => _contentTabIndex = 2);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: _buildContentPanel(
                            media: media,
                            files: files,
                            links: links,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      isGroup
                          ? l10n.membersSectionTitle
                          : l10n.peopleSectionTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: kUsers,
                      itemBuilder: (context, index) {
                        final subuser = _chatListVM.getSubusers()[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => subuser.id ==
                                        _chat?.yourUserId
                                    ? ProfileScreen(nickname: subuser.userName)
                                    : ProfileScreenOther(
                                        nickname: subuser.userName,
                                        userID: subuser.id,
                                        image: subuser.image,
                                      ),
                              ),
                            );
                          },
                          onLongPress: () {
                            _showParticipantOptions(context, index);
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: TelegramAvatar(
                                title: subuser.userName,
                                imageUrl: subuser.avatarUrl,
                                radius: 20,
                              ),
                            ),
                            title: Text(
                              subuser.userName,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              isGroup ? l10n.memberRole : l10n.participantRole,
                              style: const TextStyle(color: Color(0xFF7F91A4)),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentPanel({
    required List<PseudoMediaItem> media,
    required List<PseudoFileItem> files,
    required List<PseudoLinkItem> links,
  }) {
    switch (_contentTabIndex) {
      case 0:
        return _buildMediaGrid(media);
      case 1:
        return _buildFilesList(files);
      default:
        return _buildLinksList(links);
    }
  }

  Widget _buildMediaGrid(List<PseudoMediaItem> media) {
    if (media.isEmpty) {
      return _EmptyContentState(
        icon: Icons.photo_library_outlined,
        message: context.l10n.noSharedMedia,
      );
    }

    return GridView.builder(
      key: const ValueKey('media-grid'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: media.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.02,
      ),
      itemBuilder: (context, index) {
        final item = media[index];
        return GestureDetector(
          onTap: () => _showMediaPreview(item),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0E1621),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF243447)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildMediaImage(item),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0x00000000), Color(0xCC000000)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          item.caption,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${item.senderName} • ${item.timeLabel}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.82),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMediaImage(PseudoMediaItem item) {
    if (item.imageData != null && item.imageData!.isNotEmpty) {
      return Image.memory(
        base64.decode(item.imageData!),
        fit: BoxFit.cover,
      );
    }

    if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
      return Image.network(
        item.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFF243447),
          alignment: Alignment.center,
          child:
              const Icon(Icons.broken_image_outlined, color: Color(0xFF7F91A4)),
        ),
      );
    }

    return Image.asset(
      'assets/ppp.jpg',
      fit: BoxFit.cover,
    );
  }

  Widget _buildFilesList(List<PseudoFileItem> files) {
    if (files.isEmpty) {
      return _EmptyContentState(
        icon: Icons.insert_drive_file_outlined,
        message: context.l10n.noSharedFiles,
      );
    }

    return Column(
      key: const ValueKey('files-list'),
      children: files
          .map(
            (file) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0E1621),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF243447),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(_iconForFile(file.fileType),
                      color: const Color(0xFF2AABEE)),
                ),
                title: Text(
                  file.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${file.detailLabel} • ${file.sizeLabel}',
                  style: const TextStyle(color: Color(0xFF7F91A4)),
                ),
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: Color(0xFF7F91A4)),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildLinksList(List<PseudoLinkItem> links) {
    if (links.isEmpty) {
      return _EmptyContentState(
        icon: Icons.link_outlined,
        message: context.l10n.noSharedLinks,
      );
    }

    return Column(
      key: const ValueKey('links-list'),
      children: links
          .map(
            (link) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0E1621),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF243447),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child:
                      const Icon(Icons.link_rounded, color: Color(0xFF2AABEE)),
                ),
                title: Text(
                  link.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      link.previewLabel,
                      style: const TextStyle(color: Color(0xFF9FB0C0)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${link.url} • ${link.timeLabel}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFF7F91A4)),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.open_in_new_rounded,
                    color: Color(0xFF7F91A4)),
              ),
            ),
          )
          .toList(),
    );
  }

  IconData _iconForFile(String fileType) {
    switch (fileType) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'zip':
        return Icons.folder_zip_outlined;
      case 'audio':
        return Icons.graphic_eq_rounded;
      case 'design':
        return Icons.palette_outlined;
      default:
        return Icons.description_outlined;
    }
  }

  void _showMediaPreview(PseudoMediaItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF0E1621),
          insetPadding: const EdgeInsets.all(18),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF17212B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF243447)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 1.08,
                    child: _buildMediaImage(item),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.caption,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.senderName} • ${item.timeLabel}',
                  style: const TextStyle(color: Color(0xFF7F91A4)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showParticipantOptions(BuildContext context, int index) {
    final l10n = context.l10n;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            l10n.memberOptions,
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.white),
                title: Text(
                  l10n.removeMember,
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Логика удаления участника
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                l10n.cancelAction,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _ContentTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ContentTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2AABEE) : const Color(0xFF0E1621),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF2AABEE) : const Color(0xFF243447),
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
    );
  }
}

class _EmptyContentState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyContentState({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey<String>(message),
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1621),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF7F91A4), size: 32),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

void _showProfileOptions(BuildContext context) {
  final l10n = context.l10n;
  final ChatInfoVM chatInfoVM = ChatInfoVM();

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF17212B),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (context) {
      return SafeArea(
        child: ListTile(
          leading: const Icon(Icons.delete, color: Colors.white),
          title: Text(l10n.deleteChat,
              style: const TextStyle(color: Colors.white)),
          onTap: () async {
            Navigator.pop(context); // Закрываем меню

            bool isDeleted = await chatInfoVM.deleteNowGroup(context);
            if (!context.mounted) return;

            if (isDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.chatRemoved,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFF222222),
                ),
              );

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AllChatsPage()),
                (route) => false,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.unableToDeleteChat,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFF222222),
                ),
              );
            }
          },
        ),
      );
    },
  );
}
