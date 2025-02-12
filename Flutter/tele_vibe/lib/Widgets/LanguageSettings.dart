import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_vibe/ViewModel/registrationVM.dart';
import 'package:tele_vibe/ViewModel/SettingsVM.dart';

class LanguageSettings extends StatelessWidget {
  const LanguageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text('Выбор языка', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF222222),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Русский', style: TextStyle(color: Colors.white)),
            onTap: () {
              // логика изменения языка на русский
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Английский', style: TextStyle(color: Colors.white)),
            onTap: () {
              // логика изменения языка на английский
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Немецкий', style: TextStyle(color: Colors.white)),
            onTap: () {
              // логика изменения языка на немецкий
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}