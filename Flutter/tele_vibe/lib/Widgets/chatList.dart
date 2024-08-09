import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF8DA18B), // Основной зеленоватый фон
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          backgroundColor: const Color(0xFF3E505F), // Темно-серый цвет AppBar
          automaticallyImplyLeading: false,
          title: const Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/a/a8/Sample_Network.jpg'),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          bool showAvatar = false;

          // Показываем аватарку только для последнего сообщения группы одного пользователя
          if (index == entries.length - 1 || entries[index]['userName'] != entries[index + 1]['userName']) {
            showAvatar = !entries[index]['isMe'];
          }

          return MessageBubble(
            text: entries[index]['text'],
            isMe: entries[index]['isMe'],
            userName: entries[index]['userName'],
            time: entries[index]['time'],
            showAvatar: showAvatar,
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        height: 58.0,
        color: const Color(0xFF3E505F), // Цвет фона под полем ввода
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
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
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String userName;
  final String time;
  final bool showAvatar;

  const MessageBubble({
    required this.text,
    required this.isMe,
    required this.userName,
    required this.time,
    required this.showAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (!isMe) ...[
          // Добавляем аватарку или пустое место
          showAvatar
              ? const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/a/a8/Sample_Network.jpg'),
                  radius: 15,
                )
              : const SizedBox(width: 31), // Ширина аватарки + отступ
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFEBEBEB) : const Color(0xFF3E505F),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15.0),
                topRight: const Radius.circular(15.0),
                bottomLeft: Radius.circular(isMe ? 15.0 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 15.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(color: isMe ? Colors.black : Colors.white),
                ),
                const SizedBox(height: 5.0),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12.0,
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
