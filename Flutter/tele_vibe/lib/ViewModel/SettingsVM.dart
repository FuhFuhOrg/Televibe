// Импорт необходимых классов и интерфейсов

// Вот здесь поменяй, где ты держишь этот чертов юзер айди, потому что я в душе не чаю, какой из них именно этого пользователя
class SettingsVM {
  void changeNotifications(bool flag) {
    // Логика для отключения/включения уведомлений
  }

  void changeVolume(bool flag) {
    // Логика для убирания звука
  }

  bool getNotifications() {
    return true; // Изменить на возврат из бд
  }

  bool getVolume() {
    return false; // Изменить на возврат из бд
  }
}
