import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_vibe/Data/chats.dart';

class LocalDataSave {
  // Метод для сохранения объекта ChatsData в локальное хранилище
  static Future<void> saveChatsData() async {
    ChatCollection chatsData = Chats.value;
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(chatsData.toJson());
    await prefs.setString('chatsData', jsonString);
  }

  // Метод для загрузки объекта ChatsData из локального хранилища
  static Future<ChatCollection?> loadChatsData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('chatsData');
    if (jsonString != null) {
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      return ChatCollection.fromJson(jsonData);
    }
    return null;
  }
}
