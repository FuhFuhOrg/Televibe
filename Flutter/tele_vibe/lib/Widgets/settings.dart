import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _showDataOnLogin = true;
  bool _showPhoneNumber = true;
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Загрузка сохраненных настроек из SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showDataOnLogin = prefs.getBool('showDataOnLogin') ?? true;
      _showPhoneNumber = prefs.getBool('showPhoneNumber') ?? true;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _soundEnabled = prefs.getBool('soundEnabled') ?? true;
    });
  }

  // Сохранение настроек
  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021510),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text('Конфиденциальность', style: TextStyle(color: Colors.white)),
            initiallyExpanded: true,
            children: <Widget>[
              SwitchListTile(
                activeTrackColor: Colors.white,
                activeColor: const Color(0xFF4E8F7D),
                title: const Text('Показывать данные при входе', style: TextStyle(color: Colors.white)),
                value: _showDataOnLogin,
                onChanged: (bool value) {
                  setState(() {
                    _showDataOnLogin = value;
                  });
                  _saveSetting('showDataOnLogin', value); // Сохраняем настройку
                },
              ),
              SwitchListTile(
                activeTrackColor: Colors.white,
                activeColor: const Color(0xFF4E8F7D),
                title: const Text('Номер телефона', style: TextStyle(color: Colors.white)),
                value: _showPhoneNumber,
                onChanged: (bool value) {
                  setState(() {
                    _showPhoneNumber = value;
                  });
                  _saveSetting('showPhoneNumber', value); // Сохраняем настройку
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Уведомления и звуки', style: TextStyle(color: Colors.white)),
            initiallyExpanded: true,
            children: <Widget>[
              SwitchListTile(
                activeTrackColor: Colors.white,
                activeColor: const Color(0xFF4E8F7D),
                title: const Text('Уведомления', style: TextStyle(color: Colors.white)),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  _saveSetting('notificationsEnabled', value); // Сохраняем настройку
                },
              ),
              SwitchListTile(
                activeTrackColor: Colors.white,
                activeColor: const Color(0xFF4E8F7D),
                title: const Text('Звук', style: TextStyle(color: Colors.white)),
                value: _soundEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _soundEnabled = value;
                  });
                  _saveSetting('soundEnabled', value); // Сохраняем настройку
                },
              ),
            ],
          ),
          ListTile(
            title: const Text('Язык', style: TextStyle(color: Colors.white)),
            onTap: () {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Выбор языка', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3E505F),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Русский', style: TextStyle(color: Colors.black)),
            onTap: () {
              // логика изменения языка на русский
            },
          ),
          ListTile(
            title: const Text('Английский', style: TextStyle(color: Colors.black)),
            onTap: () {
              // логика изменения языка на английский
            },
          ),
          ListTile(
            title: const Text('Немецкий', style: TextStyle(color: Colors.black)),
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
