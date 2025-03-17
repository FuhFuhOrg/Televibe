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
}
