import 'package:flutter/material.dart';
import 'package:tele_vibe/ViewModel/AllChatsVM.dart';
import 'package:tele_vibe/Widgets/chatList.dart';
import 'package:tele_vibe/Widgets/profileScreen.dart';
import 'package:tele_vibe/Widgets/settings.dart';
// Ня

class AllChatsPage extends StatefulWidget {
  @override
  _AllChatsClassState createState() => _AllChatsClassState();
}

class _AllChatsClassState extends State<AllChatsPage> {
  int _selectedIndex = 1;
  bool _isSearching = false; // Флаг для отображения строки поиска
  final TextEditingController _searchController = TextEditingController(); // Контроллер для строки поиска
  final AllChatsVM _allChatsVM = AllChatsVM();

  // Метод для выбора экрана в зависимости от выбранного индекса
  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return Settings(); // Экран настроек
      case 1:
        return _buildChatList(); // Список чатов
      case 2:
        return ProfileScreen(nickname: 'YourNickname'); // Экран профиля
      default:
        return _buildChatList(); // По умолчанию показывается список чатов
    }
  }

  // Строим список чатов как отдельный метод
  Widget _buildChatList() {
    final List<String> entries = <String>['ff', 'gg', 'hh', 'ff', 'gg', 'hh', 'ff', 'gg', 'hh', 'ff', 'gg', 'hh'];
    return entries.isNotEmpty
        ? ListView.builder(
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onLongPress: () {
                  _showChatOptions(context);
                },
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatListPage()), // Переход на экран чата
                    );
                  },
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/a/a8/Sample_Network.jpg'),
                  ),
                  tileColor: Colors.grey,
                  textColor: Colors.black,
                  title: Text('Item ${entries[index]}'), // Название чата
                  subtitle: Text('Item ${entries[index]}'), // Сообщение
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32), // Отступ сверху
                      Text('Item ${entries[index]}'), // Время
                    ],
                  ),
                ),
              );
            },
          )
        : const Center(child: Text('You don\'t have chats('));
  }

  // Метод для отображения меню с опциями
  void _showChatOptions(BuildContext context) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        MediaQuery.of(context).size.width - 100,
        MediaQuery.of(context).size.height - 200,
        0,
        0,
      ),
      items: <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'clear_history',
          child: Text('Очистить историю'),
        ),
        const PopupMenuItem<String>(
          value: 'leave_group',
          child: Text('Выйти из группы'),
        ),
      ],
    ).then((String? value) {
      if (value != null) {
        switch (value) {
          case 'clear_history':
            // Логика для очистки истории
            _clearChatHistory();
            break;
          case 'leave_group':
            // Логика для выхода из группы
            _leaveGroup();
            break;
        }
      }
    });
  }

  void _clearChatHistory() {
    // Логика очистки истории
    print('Очистить историю');
  }

  void _leaveGroup() {
    // Логика выхода из группы
    print('Выйти из группы');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isSearching = false; // Сбрасываем строку поиска при переключении вкладок
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: (_selectedIndex == 1 || _isSearching) ? PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search chats...',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  autofocus: true,
                  onChanged: (value) {
                    // Логика поиска
                  },
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Televibe"),
                    Padding(
                      padding: EdgeInsets.all(0),
                    ),
                  ],
                ),
          actions: [
            if (!_isSearching)
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
              ),
            if (_isSearching)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                },
              ),
          ],
        ),
      ) : null,
      body: _getSelectedScreen(), // Показ выбранного экрана
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green, // Цвет активного элемента
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
