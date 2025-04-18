import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/ViewModel/chatListVM.dart';
import 'package:tele_vibe/ViewModel/chatUpdateService.dart';

import 'UnderWidgets/fileUtils.dart';
import 'chatInfo.dart';
import 'searchMessagesScreen.dart';


class ChatListPage extends StatefulWidget {
  static List<Map<String, dynamic>> currentMessages = [];
  const ChatListPage({super.key});

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatListPage> {
  //final List<Map<String, dynamic>> entries = [
  //  {'text': 'Привет!', 'isMe': false, 'userName': 'Пользователь 1', 'time': '12:01'},
  //  {'text': 'Как дела?', 'isMe': false, 'userName': 'Пользователь 1', 'time': '12:02'},
  //  {'text': 'Хорошо, а у тебя?', 'isMe': true, 'userName': 'Я', 'time': '12:03'},
  //  {'text': 'Тоже хорошо!', 'isMe': true, 'userName': 'Я', 'time': '12:04'},
  //  {'text': 'Что нового?', 'isMe': false, 'userName': 'Пользователь 2', 'time': '12:05'},
  //  {'text': 'Ничего особенного.', 'isMe': true, 'userName': 'Я', 'time': '12:06'},
  //  {'text': 'Понятно.', 'isMe': false, 'userName': 'Пользователь 2', 'time': '12:07'},
  //];

  List<Map<String, dynamic>> filteredEntries = [];
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final ChatListVM _chatListVM = ChatListVM();
  Timer? _chatRefreshTimer;
  bool _isSearching = false;
  String? _profileImagePath;

  Future<void> _refreshChat() async {
    int queueId = Chats.getValue()
        .chats
        .where((chat) => chat.chatId == Chats.nowChat)
        .firstOrNull
        ?.nowQueueId ?? -1;
    List<(String, int)> updatedQueue = await ChatUpdateService.fetchUpdatedQueue(queueId);
    List<Map<String, dynamic>> newEntries = await Chats.queueToFiltred(updatedQueue, context);
    setState(() {
      filteredEntries = newEntries;
      ChatListPage.currentMessages = newEntries;
    });
  }

  @override
  void initState() {
    super.initState();

    _refreshChat();

    _chatRefreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _refreshChat();
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _updateFilteredEntries(List<(String, int)> queueChat, BuildContext context) async {
    List<Map<String, dynamic>> newEntries = await Chats.queueToFiltred(queueChat, context);
    setState(() {
      filteredEntries = newEntries;
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

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF141414),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          backgroundColor: const Color(0xFF222222),
          automaticallyImplyLeading: false,
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatInfo(initialGroupName: 'Название группы')),
              );
            },
            child: _isSearching ? _buildSearchField() : _buildTitle(),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  // Я тут чото поменял 
                  MaterialPageRoute(builder: (context) => SearchMessagesScreen(messages: filteredEntries)),
                );
              }
            ),
          ],
        ),
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
                      final bool isLastMessageFromUser = messageIndex == filteredEntries.length - 1 ||
                          (messageIndex < filteredEntries.length - 1 &&
                          filteredEntries[messageIndex]['userName'] != filteredEntries[messageIndex + 1]['userName']);

                      return GestureDetector(
                        onLongPress: () => _showParticipantOptions(context, messageIndex),
                        child: MessageBubble(
                          text: entry['text'],
                          isMe: entry['isMe'],
                          userName: entry['userName'].toString(),
                          time: entry['time'],
                          showAvatar: !entry['isMe'] && isLastMessageFromUser,
                          showUserName: !entry['isMe'],
                          isImage: entry['isImage'],
                          imageData: entry['imageData'],
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
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Поиск...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 18.0),
    );
  }

  Widget _buildTitle() {
    int kUsers = _chatListVM.getCountUsers();
    
    return Row(
      children: <Widget>[
        const CircleAvatar(
          backgroundImage: NetworkImage(
              'https://upload.wikimedia.org/wikipedia/commons/a/a8/Sample_Network.jpg'),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _chatListVM.getNameGroup(), // Название группы
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Text(
                kUsers == 1
                  ? "${kUsers.toString()} участник"
                  : kUsers >= 2 && kUsers <= 4
                      ? "${kUsers.toString()} участника"
                      : "${kUsers.toString()} участников",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 58.0,
      color: const Color(0xFF141414),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.white),
            onPressed: () async {
              final pickedImage = await FileUtils.pickImage();

              if (pickedImage != null) {
                try {
                  // Читаем файл как байты
                  final bytes = await pickedImage.readAsBytes();
                  
                  // Декодируем изображение
                  final image = img.decodeImage(bytes);
                  if (image == null) throw Exception('Не удалось декодировать изображение');
                  
                  // Сжимаем изображение
                  //final resized = img.copyResize(image, width: 800); // уменьшаем ширину до 800px
                  final compressed = img.encodeJpg(image, quality: 100); // сжимаем с качеством 10%
                  
                  // Конвертируем в base64
                  final base64Image = base64Encode(compressed);
                  
                  // Формируем сообщение с изображением
                  final message = '<img>$base64Image</img>';
                  
                  // Отправляем сообщение
                  bool success = await _chatListVM.sendMessage(message);
                  if (success) {
                    _textController.clear();
                    _focusNode.requestFocus();
                    _scrollToBottom();
                    await _refreshChat();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Ошибка при отправке изображения: $e',
                        style: const TextStyle(color: Colors.white)
                      ),
                      backgroundColor: const Color(0xFF222222)
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Изображение не выбрано', 
                      style: TextStyle(color: Colors.white)
                    ),
                    backgroundColor: Color(0xFF222222)
                  ),
                );
              }
            },
          ),
          Expanded(
            child: TextField(
              cursorColor: Colors.white,
              focusNode: _focusNode,
              maxLines: null,
              autocorrect: true,
              enableSuggestions: true,
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Введите ваше сообщение...',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () async {
              String message = _textController.text;
              if (message.isNotEmpty) {
                bool buba = await _chatListVM.sendMessage(message);
                if(buba){
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Сообщение',
            style: TextStyle(color: Colors.white), 
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.white),
                title: const Text(
                  'Копировать',
                  style: TextStyle(color: Colors.white), 
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: filteredEntries[index]['text']));
                  Navigator.pop(context);
                },
              ),
              filteredEntries[index]['isMe'] ? ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text(
                  'Изменить',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _showEditDialog(context, index);
                },
              ) : const SizedBox.shrink(),
              filteredEntries[index]['isMe'] ? ListTile(
                leading: const Icon(Icons.delete, color: Colors.white), 
                title: const Text(
                  'Удалить',
                  style: TextStyle(color: Colors.white), 
                ),
                onTap: () async {
                  Navigator.pop(context);
  
                  await _chatListVM.deleteMessage(filteredEntries[index]['id']);
                  await _refreshChat();
                },
              ) : const SizedBox.shrink(),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Отмена',
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


  Future<void> _showEditDialog(BuildContext context, int index) async {
    TextEditingController editController = TextEditingController(text: filteredEntries[index]['text']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,  
          title: const Text(
            'Изменить сообщение',
            style: TextStyle(color: Colors.white),  
          ),
          content: TextField(
            controller: editController,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white), 
            decoration: const InputDecoration(
              hintText: 'Введите текст сообщения',
              hintStyle: TextStyle(color: Colors.white60), 
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white), 
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.white),  
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Сохранить',
                style: TextStyle(color: Colors.white),  
              ),
              onPressed: () async {
                await _chatListVM.changeMessage(editController.text, index);
                await _refreshChat();

                if (mounted) {
                  setState(() {}); // Теперь setState() вызывается после await
                }

  Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  const MessageBubble({super.key, 
    required this.text,
    required this.isMe,
    required this.userName,
    required this.time,
    required this.showAvatar,
    required this.showUserName,
    this.isImage = false,
    this.imageData,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (!isMe) ...[
          showAvatar
              ? const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/a/a8/Sample_Network.jpg'),
                  radius: 15,
                )
              : const SizedBox(width: 31),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF222222) : const Color(0xFF222222),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12.0),
                topRight: const Radius.circular(12.0),
                bottomLeft: isMe ? const Radius.circular(12.0) : Radius.zero,
                bottomRight: isMe ? Radius.zero : const Radius.circular(12.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (showUserName)
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.0),
                  ),
                if (isImage && imageData != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.memory(
                      base64.decode(imageData!),
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                    ),
                  )
                else
                  Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                const SizedBox(height: 5.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    time,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
