import 'package:flutter/material.dart';

class AddParticipantScreen extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить участника'),
        backgroundColor: const Color(0xFF3E505F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'Введите ID участника',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Логика добавления участника по ID
                String participantId = _idController.text;
                // Вы можете добавить логику для обработки ID участника здесь

                Navigator.pop(context); // Возвращаемся на предыдущий экран
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E505F),
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
