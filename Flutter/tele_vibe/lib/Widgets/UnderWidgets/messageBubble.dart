import 'package:flutter/material.dart';

// Gradient helper shared with avatar rendering
Color _avatarColor(String name) {
  const colors = [
    Color(0xFF37AEE2),
    Color(0xFFEE7A62),
    Color(0xFF4CC38A),
    Color(0xFF8E7CF6),
    Color(0xFFF2B84B),
    Color(0xFF5AC8FA),
  ];
  final idx = name.codeUnits.fold<int>(0, (s, c) => s + c) % colors.length;
  return colors[idx];
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String userName;
  final String time;
  final bool showAvatar;
  final bool showUserName;

  const MessageBubble({
    super.key,
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
              ? CircleAvatar(
                  backgroundColor: _avatarColor(userName),
                  radius: 15,
                  child: Text(
                    userName.isNotEmpty
                        ? userName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : const SizedBox(width: 31), // Ширина аватарки + отступ, ня
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width *
                  0.7, // Максимальная ширина сообщения 70% экрана
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
