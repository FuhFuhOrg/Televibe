import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchMessagesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> messages;

  const SearchMessagesScreen({super.key, required this.messages});

  @override
  _SearchMessagesScreenState createState() => _SearchMessagesScreenState();
}

class _SearchMessagesScreenState extends State<SearchMessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredMessages = [];

  @override
  void initState() {
    super.initState();
    // Изначально показываем все сообщения
    _filteredMessages = widget.messages;

    _searchController.addListener(() {
      _filterMessages(_searchController.text);
    });
  }

  void _filterMessages(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMessages = widget.messages;
      } else {
        _filteredMessages = widget.messages
            .where((message) =>
                message['text'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF222222),
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          cursorColor: Colors.white,
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search messages...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF141414),
      body: _filteredMessages.isNotEmpty
          ? ListView.builder(
              itemCount: _filteredMessages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = _filteredMessages[index];
                return ListTile(
                  title: Text(
                    message['text'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'By ${message['userName']} - ${message['time']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                'No messages found.',
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }
}
