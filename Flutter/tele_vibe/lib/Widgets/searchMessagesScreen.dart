import 'package:flutter/material.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';

class SearchMessagesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> messages;

  const SearchMessagesScreen({super.key, required this.messages});

  @override
  State<SearchMessagesScreen> createState() => _SearchMessagesScreenState();
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF17212B),
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          cursorColor: Colors.white,
          controller: _searchController,
          decoration: InputDecoration(
            hintText: l10n.searchMessagesHint,
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF0E1621),
      body: _filteredMessages.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _filteredMessages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = _filteredMessages[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF17212B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF243447)),
                  ),
                  child: ListTile(
                    title: Text(
                      message['text'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      l10n.fromUserAt(
                        userName: message['userName'].toString(),
                        time: message['time'].toString(),
                      ),
                      style: const TextStyle(color: Color(0xFF7F91A4)),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.message_outlined,
                        color: Color(0xFF7F91A4), size: 42),
                    const SizedBox(height: 12),
                    Text(
                      l10n.noMessagesFound,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _searchController.text.isEmpty
                          ? l10n.searchCurrentConversationPrompt
                          : l10n.tryAnotherKeywordOrChat,
                      style: const TextStyle(
                        color: Color(0xFF7F91A4),
                        height: 1.35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
