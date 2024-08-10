import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tele_vibe/Widgets/UnderWidgets/messageBubble.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatListPage> {
  final List<Map<String, dynamic>> entries = [
    {'text': 'Привет!', 'isMe': false, 'userName': 'Пользователь 1', 'time': '12:01'},
    {'text': 'Как дела?', 'isMe': false, 'userName': 'Пользователь 1', 'time': '12:02'},
    {'text': 'Хорошо, а у тебя?', 'isMe': true, 'userName': 'Я', 'time': '12:03'},
    {'text': 'Тоже хорошо!', 'isMe': true, 'userName': 'Я', 'time': '12:04'},
    {'text': 'Что нового?', 'isMe': false, 'userName': 'Пользователь 2', 'time': '12:05'},
    {'text': 'Ничего особенного.', 'isMe': true, 'userName': 'Я', 'time': '12:06'},
    {'text': 'Понятно.', 'isMe': false, 'userName': 'Пользователь 2', 'time': '12:07'},
  ];

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Открытие чата с прокруткой вниз
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF8DA18B), // Основной зеленоватый фон
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          backgroundColor: const Color(0xFF3E505F), // Темно-серый цвет AppBar
          automaticallyImplyLeading: false,
          title: const Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://upload.wikimedia.org/wikipedia/commons/a/a8/Sample_Network.jpg'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Name Group',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ), // Название чата
                    Text(
                      '10 участников',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ), // Кол-во участников
                  ],
                ),
              ),
              Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(10.0),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  bool showAvatar = false;

                  // Показываем аватарку только для последнего сообщения группы одного пользователя
                  if (index == entries.length - 1 || entries[index]['userName'] != entries[index + 1]['userName']) {
                    showAvatar = !entries[index]['isMe'];
                  }

                  return GestureDetector(
                    onLongPress: () => _showMessageOptions(context, index),
                    child: MessageBubble(
                      text: entries[index]['text'],
                      isMe: entries[index]['isMe'],
                      userName: entries[index]['userName'],
                      time: entries[index]['time'],
                      showAvatar: showAvatar,
                      showUserName: !entries[index]['isMe'], // Показываем ник только для других пользователей
                    ),
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 58.0,
      color: const Color(0xFF3E505F), // Цвет фона под полем ввода
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              maxLines: null,
              autocorrect: true,
              enableSuggestions: true,
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Введите ваше сообщение... ',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () {
              String message = _textController.text;
              if (message.isNotEmpty) {
                setState(() {
                  entries.add({'text': message, 'isMe': true, 'userName': 'Я', 'time': '12:05'});
                });
                _textController.clear();
                _focusNode.requestFocus();
                _scrollToBottom(); // Прокрутка вниз после отправки сообщения
              }
            },
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showMessageOptions(BuildContext context, int index) {
    FocusScope.of(context).unfocus(); // Убираем фокус с текстового поля

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Копировать'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: entries[index]['text']));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Изменить'),
              onTap: () {
                Navigator.pop(context);
                _showEditDialog(context, index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Удалить'),
              onTap: () {
                setState(() {
                  entries.removeAt(index);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    TextEditingController editController = TextEditingController(text: entries[index]['text']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Изменить сообщение'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              hintText: 'Введите текст сообщения',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () {
                setState(() {
                  entries[index]['text'] = editController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
