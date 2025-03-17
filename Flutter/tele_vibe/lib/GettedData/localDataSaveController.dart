import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_vibe/Data/chats.dart';

class LocalDataSave {
  // Метод для сохранения объекта ChatsData в локальное хранилище
  static Future<void> saveChatsData() async {
    try {
      ChatCollection chatsData = Chats.value;
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> jsonData = await chatsData.toJson();
      final String jsonString = jsonEncode(jsonData);
      await prefs.setString('chatsData', jsonString);
      print('Данные успешно сохранены');
    } catch (e) {
      print('Ошибка при сохранении данных: $e');
    }
  }

  // Метод для загрузки объекта ChatsData из локального хранилища
  static Future<ChatCollection?> loadChatsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString('chatsData');
      if (jsonString != null) {
        final Map<String, dynamic> jsonData = jsonDecode(jsonString);
        return ChatCollection.fromJson(jsonData);
      }
      print('Нет сохраненных данных');
      return null;
    } catch (e) {
      print('Ошибка при загрузке данных: $e');
      return null;
    }
  }

  // Сохранение учетных данных
  static Future<void> saveCredentials(String login, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('savedLogin', login);
      await prefs.setString('savedPassword', password);
      print('Учетные данные сохранены');
    } catch (e) {
      print('Ошибка при сохранении учетных данных: $e');
    }
  }

  // Загрузка учетных данных
  static Future<(String?, String?)> loadCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? login = prefs.getString('savedLogin');
      final String? password = prefs.getString('savedPassword');
      return (login, password);
    } catch (e) {
      print('Ошибка при загрузке учетных данных: $e');
      return (null, null);
    }
  }

  // Удаление учетных данных
  static Future<void> clearCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('savedLogin');
      await prefs.remove('savedPassword');
      print('Учетные данные удалены');
    } catch (e) {
      print('Ошибка при удалении учетных данных: $e');
    }
  }
}
