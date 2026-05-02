import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/pseudoChatApi.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/ViewModel/chatListVM.dart';
import 'package:tele_vibe/ViewModel/chatUpdateService.dart';
import 'package:tele_vibe/Widgets/UnderWidgets/telegramAvatar.dart';

import 'UnderWidgets/fileUtils.dart';
import 'chatInfo.dart';
import 'searchMessagesScreen.dart';

class ChatListPage extends StatefulWidget {
  static List<Map<String, dynamic>> currentMessages = [];
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListState();
}

class _ChatListState extends State<ChatListPage> {
  List<Map<String, dynamic>> filteredEntries = [];
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final ChatListVM _chatListVM = ChatListVM();
  Timer? _chatRefreshTimer;
  final bool _isSearching = false;
  bool _isRefreshing = false;

  Future<void> _refreshChat() async {
    if (_isRefreshing) return;
    _isRefreshing = true;

    try {
      final currentChat = Chats.getNowChat();
      if (currentChat == null) {
        if (!mounted) return;
        setState(() {
          filteredEntries = [];
          ChatListPage.currentMessages = filteredEntries;
        });
        return;
      }

      if (PseudoChatApi.isEnabled || currentChat.isPreparedData) {
        if (!mounted) return;
        setState(() {
          filteredEntries = List<Map<String, dynamic>>.from(
            currentChat.messages,
          );
          ChatListPage.currentMessages = filteredEntries;
        });
        return;
      }

      final queueId = currentChat.nowQueueId;
      final updatedQueue = await ChatUpdateService.fetchUpdatedQueue(queueId)
          .timeout(const Duration(seconds: 4), onTimeout: () {
        debugPrint('Chat refresh timed out while fetching queue');
        return Chats.getNowChatQueue();
      });
      if (!mounted) return;

      final newEntries = await Chats.queueToFiltred(updatedQueue, context)
          .timeout(const Duration(seconds: 4), onTimeout: () {
        debugPrint('Chat refresh timed out while processing queue');
        return currentChat.messages;
      });
      if (!mounted) return;

      setState(() {
        filteredEntries = newEntries;
        ChatListPage.currentMessages = newEntries;
      });
    } catch (error) {
      debugPrint('Chat refresh failed: $error');
    } finally {
      _isRefreshing = false;
    }
  }

  @override
  void initState() {
    super.initState();

    _refreshChat();

    final currentChat = Chats.getNowChat();
    if (!PseudoChatApi.isEnabled && currentChat?.isPreparedData != true) {
      _chatRefreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        _refreshChat();
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _chatRefreshTimer?.cancel();
    _searchController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chat = Chats.getNowChat();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF0E1621),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17212B),
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChatInfo(initialGroupName: l10n.chatDetailsTitle)),
            );
          },
          child: _isSearching ? _buildSearchField() : _buildTitle(chat),
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.search_rounded, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SearchMessagesScreen(messages: filteredEntries)),
                );
              }),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            onPressed: () => _showChatActions(context, chat),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) => true,
                  child: ListView.builder(
                    reverse: true,
                    itemCount: filteredEntries.length,
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final messageIndex = filteredEntries.length - 1 - index;
                      final entry = filteredEntries[messageIndex];

                      // Определяем, является ли текущее сообщение последним от пользователя
                      final bool isLastMessageFromUser =
                          messageIndex == filteredEntries.length - 1 ||
                              (messageIndex < filteredEntries.length - 1 &&
                                  filteredEntries[messageIndex]['userName'] !=
                                      filteredEntries[messageIndex + 1]
                                          ['userName']);

                      return GestureDetector(
                        onLongPress: () =>
                            _showParticipantOptions(context, messageIndex),
                        child: MessageBubble(
                          text: entry['text'],
                          isMe: entry['isMe'],
                          userName: entry['userName'].toString(),
                          time: entry['time'].toString(),
                          showAvatar: !entry['isMe'] && isLastMessageFromUser,
                          showUserName:
                              !entry['isMe'] && (chat?.isGroup ?? false),
                          isImage: entry['isImage'] == true,
                          imageData: entry['imageData'] as String?,
                          imageUrl: entry['imageUrl'] as String?,
                          avatarUrl: entry['senderAvatarUrl'] as String?,
                          caption: entry['caption'] as String?,
                          status: entry['status'] as String?,
                          isEdited: entry['isEdited'] == true,
                        ),
                      );
                    },
                  ),
                ),
              ),
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    final l10n = context.l10n;

    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: l10n.messageSearchHint,
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 18.0),
    );
  }

  Widget _buildTitle(ChatData? chat) {
    if (chat == null) return const SizedBox.shrink();
    final l10n = context.l10n;
    int kUsers = _chatListVM.getCountUsers();

    return Row(
      children: <Widget>[
        TelegramAvatar(
          title: chat.chatName,
          imageUrl: chat.avatarUrl,
          radius: 20,
          isGroup: chat.isGroup,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _chatListVM.getNameGroup(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                chat.isGroup
                    ? l10n.memberCount(count: kUsers)
                    : l10n.lastSeenRecently,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7F91A4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      color: const Color(0xFF17212B),
      child: Row(
        children: <Widget>[
          IconButton(
            icon:
                const Icon(Icons.attach_file_rounded, color: Color(0xFF7F91A4)),
            onPressed: () async {
              final pickedImage = await FileUtils.pickImage();
              if (!mounted) return;

              if (pickedImage != null) {
                try {
                  // Читаем файл как байты
                  final bytes = await pickedImage.readAsBytes();

                  // Декодируем изображение
                  final image = img.decodeImage(bytes);
                  if (image == null) {
                    throw Exception('Unable to decode image');
                  }

                  // Сжимаем изображение
                  //final resized = img.copyResize(image, width: 800); // уменьшаем ширину до 800px
                  final compressed = img.encodeJpg(image,
                      quality: 100); // сжимаем с качеством 10%

                  // Конвертируем в base64
                  final base64Image = base64Encode(compressed);

                  // Формируем сообщение с изображением
                  final message = '<img>$base64Image</img>';

                  // Отправляем сообщение
                  bool success = await _chatListVM.sendMessage(message);
                  if (!mounted) return;
                  if (success) {
                    _textController.clear();
                    _focusNode.requestFocus();
                    _scrollToBottom();
                    await _refreshChat();
                  }
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(l10n.imageSendFailed(error: '$e'),
                            style: const TextStyle(color: Colors.white)),
                        backgroundColor: const Color(0xFF222222)),
                  );
                }
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(l10n.imageNotSelected,
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: const Color(0xFF222222)),
                );
              }
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF0E1621),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF243447)),
              ),
              child: TextField(
                cursorColor: const Color(0xFF2AABEE),
                focusNode: _focusNode,
                maxLines: null,
                autocorrect: true,
                enableSuggestions: true,
                controller: _textController,
                decoration: InputDecoration(
                  hintText: l10n.messageInputHint,
                  hintStyle: const TextStyle(color: Color(0xFF7F91A4)),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.send_rounded, color: Color(0xFF2AABEE)),
            onPressed: () async {
              String message = _textController.text;
              if (message.isNotEmpty) {
                bool buba = await _chatListVM.sendMessage(message);
                if (!mounted) return;
                if (buba) {
                  _textController.clear();
                  _focusNode.requestFocus();
                  _scrollToBottom();

                  //await Future.delayed(const Duration(milliseconds: 200));

                  await _refreshChat();
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  void _showParticipantOptions(BuildContext context, int index) {
    if (index < 0 || index >= filteredEntries.length) return;

    final l10n = context.l10n;

    final entry = filteredEntries[index];
    final messageText = entry['text']?.toString() ?? '';
    final messageId = entry['id'] is int
        ? entry['id'] as int
        : int.tryParse(entry['id']?.toString() ?? '') ?? index;
    final isOwnMessage = entry['isMe'] == true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            l10n.messageActionsTitle,
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.white),
                title: Text(
                  l10n.copyAction,
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: messageText));
                  Navigator.pop(context);
                },
              ),
              isOwnMessage
                  ? ListTile(
                      leading: const Icon(Icons.edit, color: Colors.white),
                      title: Text(
                        l10n.editAction,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        await _showEditDialog(
                          context,
                          messageId,
                          messageText,
                        );
                      },
                    )
                  : const SizedBox.shrink(),
              isOwnMessage
                  ? ListTile(
                      leading: const Icon(Icons.delete, color: Colors.white),
                      title: Text(
                        l10n.deleteAction,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () async {
                        Navigator.pop(context);

                        await _chatListVM.deleteMessage(messageId);
                        await _refreshChat();
                      },
                    )
                  : const SizedBox.shrink(),
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

  void _showChatActions(BuildContext context, ChatData? chat) {
    if (chat == null) return;

    final l10n = context.l10n;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17212B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.info_outline_rounded, color: Colors.white),
                title: Text(l10n.viewDetailsAction,
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatInfo(initialGroupName: chat.chatName),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy_rounded, color: Colors.white),
                title: Text(l10n.copyChatId,
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: chat.chatId));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_downward_rounded,
                    color: Colors.white),
                title: Text(l10n.jumpToLatest,
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _scrollToBottom();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    int messageId,
    String initialText,
  ) async {
    final l10n = context.l10n;
    final editController = TextEditingController(text: initialText);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            l10n.editMessageTitle,
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: editController,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: l10n.enterMessageTextHint,
              hintStyle: const TextStyle(color: Colors.white60),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
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
            TextButton(
              child: Text(
                l10n.saveAction,
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await _chatListVM.changeMessage(editController.text, messageId);
                await _refreshChat();

                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    editController.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String userName;
  final String time;
  final bool showAvatar;
  final bool showUserName;
  final bool isImage;
  final String? imageData;
  final String? imageUrl;
  final String? avatarUrl;
  final String? caption;
  final String? status;
  final bool isEdited;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.userName,
    required this.time,
    required this.showAvatar,
    required this.showUserName,
    this.isImage = false,
    this.imageData,
    this.imageUrl,
    this.avatarUrl,
    this.caption,
    this.status,
    this.isEdited = false,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor =
        isMe ? const Color(0xFF2B5278) : const Color(0xFF182533);
    final textColor = isMe ? Colors.white : const Color(0xFFEAF2F8);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (!isMe) ...[
          showAvatar
              ? TelegramAvatar(
                  title: userName,
                  imageUrl: avatarUrl,
                  radius: 16,
                )
              : const SizedBox(width: 32),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.76,
            ),
            margin: EdgeInsets.only(
              left: isMe ? 54 : 0,
              right: isMe ? 6 : 54,
              top: 4,
              bottom: 4,
            ),
            padding: const EdgeInsets.fromLTRB(11, 8, 11, 6),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 5),
                bottomRight: Radius.circular(isMe ? 5 : 16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (showUserName)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      userName,
                      style: const TextStyle(
                        color: Color(0xFF6BB7E8),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (isImage) _buildImage(context),
                if (!isImage || (caption?.isNotEmpty ?? false))
                  Text(
                    isImage ? caption! : text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15.5,
                      height: 1.25,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isEdited)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          context.l10n.editedLabel,
                          style: const TextStyle(
                            color: Color(0x99FFFFFF),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0x99FFFFFF),
                        fontSize: 11.5,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        status == 'read'
                            ? Icons.done_all_rounded
                            : Icons.done_rounded,
                        color: const Color(0xFF8FD8FF),
                        size: 15,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.58;
    final image = imageUrl != null && imageUrl!.isNotEmpty
        ? Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            width: width,
            height: width * 0.72,
            errorBuilder: (_, __, ___) => _imageFallback(width),
          )
        : imageData != null
            ? Image.memory(
                base64.decode(imageData!),
                fit: BoxFit.cover,
                width: width,
                height: width * 0.72,
              )
            : _imageFallback(width);

    return Padding(
      padding: EdgeInsets.only(bottom: caption?.isNotEmpty == true ? 7 : 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: image,
      ),
    );
  }

  Widget _imageFallback(double width) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/ppp.jpg',
        fit: BoxFit.cover,
        width: width,
        height: width * 0.72,
      ),
    );
  }
}
