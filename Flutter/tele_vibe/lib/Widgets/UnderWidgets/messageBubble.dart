import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String userName;
  final String time;
  final bool showAvatar;
  final bool showUserName;

  const MessageBubble({super.key, 
    required this.text,
    required this.isMe,
    required this.userName,
    required this.time,
    required this.showAvatar,
    required this.showUserName,
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
              : const SizedBox(width: 31), // Ширина аватарки + отступ, ня
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7, // Максимальная ширина сообщения 70% экрана
            ),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isMe ? Colors.green : Colors.blue,
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
                      fontSize: 12.0,
                    ),
                  ),
                Text(
                  text,
                  style: TextStyle(
                    color: isMe ? Colors.black : Colors.white,
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
                      fontSize: 12.0,
                    ),
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
