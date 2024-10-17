import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/ViewModel/allChatsVM.dart';
import 'package:tele_vibe/Widgets/chatList.dart';
import 'package:tele_vibe/Widgets/profileScreen.dart';
import 'package:tele_vibe/Widgets/settings.dart';
import 'package:tele_vibe/Widgets/ChatGroupOptionsPage.dart';

class AllChatsPage extends StatefulWidget {
  const AllChatsPage({super.key});

  @override
  _AllChatsClassState createState() => _AllChatsClassState();
}

class _AllChatsClassState extends State<AllChatsPage> {
  int _selectedIndex = 1;
  bool _isSearching = false; // Флаг для отображения строки поиска
  final TextEditingController _searchController = TextEditingController(); // Контроллер для строки поиска
  final AllChatsVM _allChatsVM = AllChatsVM();
  late final StreamSubscription subscriptionChats;
  ChatsData chatsData = ChatsData();
  // ПРОШУ ИЛЬЯ ПИШИ ЭТО ПРОЩУ
  @override
  void initState() {
    subscriptionChats = Chats.onValueChanged.listen((newValue) {
      chatsData = newValue;
      _getSelectedScreen();
    });
    super.initState();
  }
  // ПРОШУ ИЛЬЯ ПИШИ ЭТО ПРОЩУ, ЭТО ТОЖЕ
  @override
  void dispose() {
    _allChatsVM.dispose();
    super.dispose();
  }

  // Метод для выбора экрана в зависимости от выбранного индекса
  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const Settings(); // Экран настроек
      case 1:
        return _buildChatList(); // Список чатов
      case 2:
        return const ProfileScreen(nickname: 'YourNickname'); // Экран профиля
      default:
        return _buildChatList(); // По умолчанию показывается список чатов
    }
  }

  // Строим список чатов как отдельный метод
  Widget _buildChatList() {
    return chatsData.chats.isNotEmpty
        ? ListView.builder(
            itemCount: chatsData.chats.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onLongPress: () {
                  _showChatOptions(context);
                },
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatListPage()), // Переход на экран чата
                    );
                  },
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/a/a8/Sample_Network.jpg'),
                  ),
                  tileColor: Colors.grey,
                  textColor: Colors.black,
                  title: Text('Item ${chatsData.chats[index]}'), // Название чата
                  subtitle: Text('Item ${chatsData.chats[index]}'), // Сообщение
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32), // Отступ сверху
                      Text('Item ${chatsData.chats[index]}'), // Время
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
    // Убираем создание нового экземпляра AllChatsVM
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
            _allChatsVM.clearChatHistory();
            break;
          case 'leave_group':
            // Логика для выхода из группы
            _allChatsVM.leaveGroup(); 
            break;
        }
      }
    });
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
    appBar: (_selectedIndex == 1 || _isSearching)
        ? PreferredSize(
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
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Переход на новую активность
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatGroupOptionsPage()), // Заменить переход на норм активность когда не в падлу будет
                    );
                  },
                ),
              ],
            ),
          )
        : null,
    body: _getSelectedScreen(), // Показ выбранного экрана
    bottomNavigationBar: BottomNavigationBar(
      selectedItemColor: Colors.green,
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
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatGroupOptionsPage()),
        );
      },
      child: const Icon(Icons.add),
    ),
  );
}

}
