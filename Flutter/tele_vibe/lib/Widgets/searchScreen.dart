import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ChatData> _filteredChats = [];
  ChatsData chatsData = ChatsData();


// Массив данных, заполняется сразу из бд или из очереди
  @override
  void initState() {
    super.initState();
    // Предзаполняем данные чатов, которые будут использоваться для поиска. Это временно, пока нет нормального сервера
    chatsData = ChatsData(chats: [
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
    ]);
    _filteredChats = chatsData.chats; // Изначально показываем все чаты
  }

  void _searchChats(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredChats = chatsData.chats; // Показываем все чаты
      } else {
        _filteredChats = chatsData.chats
            .where((chat) => chat.chatName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF052018),
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search chats...',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _searchChats,
        ),
      ),
      backgroundColor: const Color(0xFF021510),
      body: _filteredChats.isNotEmpty
          ? ListView.builder(
              itemCount: _filteredChats.length,
              itemBuilder: (BuildContext context, int index) {
                final chat = _filteredChats[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/a/a8/Sample_Network.jpg'),
                  ),
                  tileColor: const Color(0xFF021510),
                  textColor: Colors.white,
                  title: Text(chat.chatName),
                  subtitle: Text(chat.message),
                  trailing: Text(
                    DateFormat.jm().format(chat.time),
                    style: const TextStyle(color: Colors.white54),
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                'No chats found.',
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }
}
