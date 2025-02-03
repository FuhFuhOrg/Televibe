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
    _controller = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Изменить ${widget.title}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, _controller.text);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          cursorColor: Colors.white,
          controller: _controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Введите ${widget.title}',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
