import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/ViewModel/allChatsVM.dart';
import 'package:tele_vibe/Widgets/chatList.dart';
import 'package:tele_vibe/Widgets/profileScreen.dart';
import 'package:tele_vibe/Widgets/settings.dart';
import 'package:tele_vibe/Widgets/chatGroupOptionsPage.dart';
import 'package:tele_vibe/Widgets/searchScreen.dart';

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






// ВЕЛИКИЙ КОСТЫЛЬ, ПОКА НЕТ БД


  // 
//          ТЫ, СИН ШЛЮХИ ЕБАНОЙ
//          ЕСЛИ ТЫ ЭТО УБЕРЕШЬ
//          Я ВСЮ ТВОЮ РОДОСЛОВНУЮ
//          С ПЕЧКОЙ ПОЗНАКОМЛЮ
  //




  final List<ChatData> _initialChats = [
    ChatData(
      chatName: 'Chat 1',
      message: 'куплю пива возьму в рот?',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      nowQueueId: 1,
    ),
    ChatData(
      chatName: 'Chat 2',
      message: 'шлома??',
      time: DateTime.now().subtract(const Duration(minutes: 10)),
      nowQueueId: 2,
    ),
    ChatData(
      chatName: 'Chat 3',
      message: 'Don’t forget to send the report.',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      nowQueueId: 3,
    ),
    ChatData(
      chatName: 'Chat 1',
      message: 'Hello, how are you?',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      nowQueueId: 1,
    ),
    ChatData(
      chatName: 'Chat 2',
      message: 'Are we still on for the meeting?',
      time: DateTime.now().subtract(const Duration(minutes: 10)),
      nowQueueId: 2,
    ),
    ChatData(
      chatName: 'Chat 3',
      message: 'Don’t forget to send the report.',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      nowQueueId: 3,
    ),
    ChatData(
      chatName: 'Chat 1',
      message: 'Hello, how are you?',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      nowQueueId: 1,
    ),
    ChatData(
      chatName: 'Chat 2',
      message: 'Are we still on for the meeting?',
      time: DateTime.now().subtract(const Duration(minutes: 10)),
      nowQueueId: 2,
    ),
    ChatData(
      chatName: 'Chat 3',
      message: 'Don’t forget to send the report.',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      nowQueueId: 3,
    ),
    ChatData(
      chatName: 'Chat 1',
      message: 'Hello, how are you?',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      nowQueueId: 1,
    ),
    ChatData(
      chatName: 'Chat 2',
      message: 'Are we still on for the meeting?',
      time: DateTime.now().subtract(const Duration(minutes: 10)),
      nowQueueId: 2,
    ),
    ChatData(
      chatName: 'Chat 3',
      message: 'Don’t forget to send the report.',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      nowQueueId: 3,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Инициализируем chatsData начальными значениями
    chatsData = ChatsData(chats: _initialChats);
    subscriptionChats = Chats.onValueChanged.listen((newValue) {
      chatsData = newValue;
      _getSelectedScreen();
    });
  }


  // 
//          ТЫ, СИН ШЛЮХИ ЕБАНОЙ
//          ЕСЛИ ТЫ ЭТО УБЕРЕШЬ
//          Я ВСЮ ТВОЮ РОДОСЛОВНУЮ
//          С ПЕЧКОЙ ПОЗНАКОМЛЮ
  //









  // @override
  // void initState() {
  //   subscriptionChats = Chats.onValueChanged.listen((newValue) {
  //     chatsData = newValue;
  //     _getSelectedScreen();
  //   });
  //   super.initState();
  // }

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
            final chat = chatsData.chats[index]; // Ссылка на текущий чат
            return GestureDetector(
              onLongPress: () {
                _showParticipantOptions(context, index);
              },
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatListPage()), // Переход на экран чата
                  );
                },
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/a/a8/Sample_Network.jpg'), // Заменить на фотографию из БД
                ),
                tileColor: const Color(0xFF021510),
                textColor: Colors.white,
                title: Text(chat.chatName), // Название чата
                subtitle: Text(chat.message), // Сообщение
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32), // Отступ сверху
                    Text(
                      DateFormat.jm().format(chat.time), // Форматирование времени
                    ),
                  ],
                ),
              ),
            );
          },
        )
      : const Center(
          child: Text(
            'You don\'t have chats(',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        );
  }

  void _showParticipantOptions(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Чат',
            style: TextStyle(color: Colors.white), 
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.white),
                title: const Text(
                  'Очистить историю',
                  style: TextStyle(color: Colors.white), 
                ),
                onTap: () {
                  _allChatsVM.clearChatHistory();
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text(
                  'Выйти из группы',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _allChatsVM.leaveGroup();
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

/*
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
*/

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isSearching = false; // Сбрасываем строку поиска при переключении вкладок
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021510),
      appBar: (_selectedIndex == 1)
          ? PreferredSize(
              preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
              child: AppBar(
                backgroundColor: const Color(0xFF052018),
                automaticallyImplyLeading: false,
                title: const Text(
                  "Televibe", 
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () {
                      // Переход на новую активность
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchScreen()),
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
      body: _getSelectedScreen(), // Показ выбранного экрана
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF021510),
        selectedItemColor: const Color(0xFF368F77),
        unselectedItemColor: Colors.white,
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
            MaterialPageRoute(builder: (context) => const ChatGroupOptionsPage()),
          );
        },
        backgroundColor: const Color(0xFF052018),
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
