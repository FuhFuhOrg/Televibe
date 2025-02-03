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
  ChatCollection chatsData = ChatCollection();


// Массив данных, заполняется сразу из бд или из очереди
  @override
  void initState() {
    super.initState();
    // Предзаполняем данные чатов, которые будут использоваться для поиска. Это временно, пока нет нормального сервера
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
        backgroundColor: const Color(0xFF222222),
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search chats...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _searchChats,
        ),
      ),
      backgroundColor: const Color(0xFF141414),
      body: _filteredChats.isNotEmpty
          ? ListView.builder(
              itemCount: _filteredChats.length,
              itemBuilder: (BuildContext context, int index) {
                final chat = _filteredChats[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/a/a8/Sample_Network.jpg'),
                  ),
                  tileColor: const Color(0xFF141414),
                  textColor: Colors.white,
                  title: Text(chat.chatName),
                  subtitle: Text(chat.getLastMessage()),
                  //trailing: Text(
                    //DateFormat.jm().format(chat.time),
                    //style: const TextStyle(color: Colors.white54),
                  //),
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
