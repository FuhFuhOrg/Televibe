import 'package:flutter/material.dart';

class PermissionsScreen extends StatelessWidget {
  final String nickname;

  PermissionsScreen({required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8DA18B),
      appBar: AppBar(
        title: const Text('Изменить разрешения'),
        backgroundColor: const Color(0xFF3E505F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Изменить разрешения для: $nickname',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            // Пример чекбоксов для изменения разрешений
            CheckboxListTile(
              title: const Text('Разрешение 1'),
              value: true,
              onChanged: (bool? value) {
                // Логика изменения разрешения
              },
            ),
            CheckboxListTile(
              title: const Text('Разрешение 2'),
              value: false,
              onChanged: (bool? value) {
                // Логика изменения разрешения
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Логика сохранения изменений разрешений
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
