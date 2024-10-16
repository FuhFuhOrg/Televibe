import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8DA18B),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text('Конфиденциальность'),
            initiallyExpanded: true,  // Добавляем эту строку для автоматического разворачивания
            children: <Widget>[
              SwitchListTile(
                title: const Text('Показывать данные при входе'),
                value: true, // можно заменить на переменную для динамического управления
                onChanged: (bool value) {
                  // логика изменения состояния
                },
              ),
              SwitchListTile(
                title: const Text('Номер телефона'),
                value: false, // можно заменить на переменную для динамического управления
                onChanged: (bool value) {
                  // логика изменения состояния
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Уведомления и звуки'),
            initiallyExpanded: true,  // Добавляем эту строку для автоматического разворачивания
            children: <Widget>[
              SwitchListTile(
                title: const Text('Уведомления'),
                value: true, // можно заменить на переменную для динамического управления
                onChanged: (bool value) {
                  // логика изменения состояния
                },
              ),
              SwitchListTile(
                title: const Text('Звук'),
                value: true, // можно заменить на переменную для динамического управления
                onChanged: (bool value) {
                  // логика изменения состояния
                },
              ),
            ],
          ),
          ListTile(
            title: const Text('Язык'),
            onTap: () {
              // логика перехода на экран выбора языка
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguageSettings()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class LanguageSettings extends StatelessWidget {
  const LanguageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор языка'),
        backgroundColor: const Color(0xFF3E505F),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Русский'),
            onTap: () {
              // логика изменения языка на русский
            },
          ),
          ListTile(
            title: const Text('Английский'),
            onTap: () {
              // логика изменения языка на английский
            },
          ),
          ListTile(
            title: const Text('Немецкий'),
            onTap: () {
              // логика изменения языка на немецкий
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Settings(),
  ));
}
