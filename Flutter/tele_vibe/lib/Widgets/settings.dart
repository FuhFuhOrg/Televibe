import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_vibe/ViewModel/registrationVM.dart';
import 'package:tele_vibe/ViewModel/SettingsVM.dart';
import 'package:tele_vibe/Widgets/LanguageSettings.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool _notifications;
  late bool _sound;
  final RegistrationVM _registrationVM = RegistrationVM();
  final SettingsVM _settingsVM = SettingsVM();

  @override
  void initState() {
    super.initState();
    _notifications = _settingsVM.getNotifications();
    _sound = _settingsVM.getVolume();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: ListView(
        children: [
          /*
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
          */
          ExpansionTile(
            title: const Text('Уведомления и звуки', style: TextStyle(color: Colors.white)),
            iconColor: Colors.white,
            initiallyExpanded: true,
            children: <Widget>[
              SwitchListTile(
                title: const Text('Уведомления', style: TextStyle(color: Colors.white)),
                value: _notifications,
                onChanged: (bool value) {
                  setState(() {
                    // сначала изменяем
                    _settingsVM.changeNotifications(value);
                    _notifications = value;
                  });
                },
                activeColor: Colors.black,
                activeTrackColor: Colors.white,
                inactiveThumbColor: Colors.black,
                inactiveTrackColor: Colors.white
              ),
              SwitchListTile(
                title: const Text('Звук', style: TextStyle(color: Colors.white)),
                value: _sound,
                onChanged: (bool value) {
                  setState(() {
                    _settingsVM.changeVolume(value);
                    _sound = value;
                  });
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