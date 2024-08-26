import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  final String nickname;

  Settings({required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8DA18B),
      appBar: AppBar(
        title: Text(nickname),
        backgroundColor: const Color(0xFF3E505F),
      ),
      body: Center(
        child: Text(
          'Профиль: $nickname',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
