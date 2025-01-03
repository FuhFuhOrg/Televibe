import 'package:flutter/material.dart';

class AddParticipantScreen extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  AddParticipantScreen({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _idController,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                labelText: 'Введите ID участника',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onEditingComplete: () {
                // Закрываем клавиатуру при завершении ввода
                _focusNode.unfocus();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String participantId = _idController.text;
                // Логика для обработки ID участника

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
