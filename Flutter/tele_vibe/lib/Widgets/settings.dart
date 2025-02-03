import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_vibe/ViewModel/registrationVM.dart';

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
  final RegistrationVM _registrationVM = RegistrationVM();

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
      backgroundColor: const Color(0xFF141414),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text('Конфиденциальность', style: TextStyle(color: Colors.white)),
            iconColor: Colors.white,
            initiallyExpanded: true,
            children: <Widget>[
              SwitchListTile(
                title: const Text('Показывать данные при входе', style: TextStyle(color: Colors.white)),
                value: _showDataOnLogin,
                onChanged: (bool value) {
                  setState(() {
                    _showDataOnLogin = value;
                  });
                  _saveSetting('showDataOnLogin', value); // Сохраняем настройку
                },
                activeColor: Colors.black,
                activeTrackColor: Colors.white,
                inactiveThumbColor: Colors.black,
                inactiveTrackColor: Colors.white
              ),
              SwitchListTile(
                title: const Text('Номер телефона', style: TextStyle(color: Colors.white)),
                value: _showPhoneNumber,
                onChanged: (bool value) {
                  setState(() {
                    _showPhoneNumber = value;
                  });
                  _saveSetting('showPhoneNumber', value); // Сохраняем настройку
                },
                activeColor: Colors.black,
                activeTrackColor: Colors.white,
                inactiveThumbColor: Colors.black,
                inactiveTrackColor: Colors.white
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Уведомления и звуки', style: TextStyle(color: Colors.white)),
            iconColor: Colors.white,
            initiallyExpanded: true,
            children: <Widget>[
              SwitchListTile(
                title: const Text('Уведомления', style: TextStyle(color: Colors.white)),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  _saveSetting('notificationsEnabled', value); // Сохраняем настройку
                },
                activeColor: Colors.black,
                activeTrackColor: Colors.white,
                inactiveThumbColor: Colors.black,
                inactiveTrackColor: Colors.white
              ),
              SwitchListTile(
                title: const Text('Звук', style: TextStyle(color: Colors.white)),
                value: _soundEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _soundEnabled = value;
                  });
                  _saveSetting('soundEnabled', value); // Сохраняем настройку
                },
                activeColor: Colors.black,
                activeTrackColor: Colors.white,
                inactiveThumbColor: Colors.black,
                inactiveTrackColor: Colors.white
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
          ListTile(
            title: const Text('Выйти из приложения', style: TextStyle(color: Colors.white)),
            onTap: () {
              _registrationVM.navigateToLoginPage(context); // просто вызываю метод navigateToLoginPage
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

void main() {
  runApp(const MaterialApp(
    home: Settings(),
  ));
}
