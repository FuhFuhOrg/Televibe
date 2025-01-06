import 'package:flutter/material.dart';

// Я ТАКОЕ ГОВНО СДЕЛАЛ, НО, пусть уж останется
class AddParticipantScreen extends StatelessWidget {
  final TextEditingController _idController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  AddParticipantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text('Добавить участника', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF222222),
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
                fillColor: Colors.white,
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
                backgroundColor: const Color(0xFF222222),
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
