import 'package:flutter/material.dart';

class RenameScreen extends StatelessWidget {
  final String nickname;

  const RenameScreen({super.key, required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8DA18B),
      appBar: AppBar(
        title: const Text('Переименовать участника'),
        backgroundColor: const Color(0xFF3E505F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Переименовать: $nickname',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Новое имя',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Логика сохранения нового имени
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E505F),
              ),
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
