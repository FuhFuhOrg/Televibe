


class ChatListVM {


  List<Map<String, dynamic>> queueToFiltred(List<String> queueChat){
    List<Map<String, dynamic>> messages = [];

    for (String command in queueChat) {
      if (command.startsWith('+')) {
        // Добавление нового сообщения
        messages.add({
          'text': command.substring(2), // Убираем '+ ' и оставляем текст
          'isMe': false, // По умолчанию, можно дополнительно обрабатывать
          'userName': 'Пользователь', // Можно добавить логику определения пользователя
          'time': '12:00' // Можно добавить актуальное время
        });
      } else if (command.startsWith('*')) {
        // Изменение сообщения
        List<String> parts = command.substring(2).split(' '); // Убираем '* ' и разделяем ID и новый текст
        int index = int.tryParse(parts[0]) ?? -1;
        if (index >= 0 && index < messages.length) {
          messages[index]['text'] = parts.sublist(1).join(' '); // Соединяем оставшуюся часть в новый текст
        }
      } else if (command.startsWith('-')) {
        // Удаление сообщения
        int index = int.tryParse(command.substring(2)) ?? -1; // Убираем '- ' и парсим ID
        if (index >= 0 && index < messages.length) {
          messages.removeAt(index);
        }
      }
    }

    return messages;
  }
}