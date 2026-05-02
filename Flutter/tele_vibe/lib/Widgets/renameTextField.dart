import 'package:flutter/material.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';

class RenameTextField extends StatefulWidget {
  final String title;
  final String currentText;

  const RenameTextField(
      {super.key, required this.title, required this.currentText});

  @override
  State<RenameTextField> createState() => _RenameTextFieldState();
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
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17212B),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.title,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.editValueDescription,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              cursorColor: const Color(0xFF2AABEE),
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: l10n.editValueHint,
                hintStyle:
                    TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                filled: true,
                fillColor: const Color(0xFF17212B),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF243447)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF2AABEE)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
