import 'package:flutter/material.dart';

class AddParticipantScreen extends StatefulWidget {
  @override
  _AddParticipantScreenState createState() => _AddParticipantScreenState();
}

class _AddParticipantScreenState extends State<AddParticipantScreen> {
  final TextEditingController _idController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _idController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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
              cursorColor: Colors.white,
              controller: _idController,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                labelText: 'Введите ID участника',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
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
                print("Введенный ID участника: $participantId");

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