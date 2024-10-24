import 'package:flutter/material.dart';

class RenameTextField extends StatefulWidget {
  final String title;
  final String currentText;

  const RenameTextField({super.key, required this.title, required this.currentText});

  @override
  _RenameTextFieldState createState() => _RenameTextFieldState();
}

class _RenameTextFieldState extends State<RenameTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021510),
      appBar: AppBar(
        backgroundColor: const Color(0xFF021510),
        title: Text(
          'Изменить ${widget.title}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white), // Белая иконка
            onPressed: () {
              Navigator.pop(context, _controller.text); // Возвращаем введенный текст
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.white), // Белый текст
          decoration: InputDecoration(
            hintText: 'Введите ${widget.title}',
            hintStyle: const TextStyle(color: Colors.white54), // Белый текст с меньшей прозрачностью для подсказки
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white), // Белая линия под полем
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white), // Белая линия, когда фокус на поле
            ),
          ),
        ),
      ),
    );
  }
}
