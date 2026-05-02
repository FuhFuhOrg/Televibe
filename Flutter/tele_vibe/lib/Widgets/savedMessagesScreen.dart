import 'package:flutter/material.dart';

class SavedMessagesScreen extends StatefulWidget {
  const SavedMessagesScreen({super.key});

  @override
  State<SavedMessagesScreen> createState() => _SavedMessagesScreenState();
}

class _SavedMessagesScreenState extends State<SavedMessagesScreen> {
  int _selectedFilter = 0;
  static const _filters = ['All', 'Photos', 'Files', 'Links', 'Audio'];

  static final _messages = [
    _SavedItem(
      type: _ItemType.text,
      sender: 'You',
      text: 'Remember to review the design spec before the meeting.',
      time: 'Today, 09:41',
    ),
    _SavedItem(
      type: _ItemType.image,
      sender: 'You',
      text: 'Screenshot from the dashboard',
      time: 'Today, 08:15',
    ),
    _SavedItem(
      type: _ItemType.link,
      sender: 'You',
      text: 'https://flutter.dev/docs\nFlutter Documentation — official reference',
      time: 'Yesterday, 22:30',
    ),
    _SavedItem(
      type: _ItemType.file,
      sender: 'You',
      text: 'Q3_Report_Final.pdf  •  1.4 MB',
      time: 'Yesterday, 18:10',
    ),
    _SavedItem(
      type: _ItemType.audio,
      sender: 'You',
      text: 'Voice note  •  0:42',
      time: 'Mon, 11:05',
    ),
  ];

  List<_SavedItem> get _filtered {
    if (_selectedFilter == 0) return _messages;
    final type = [
      null,
      _ItemType.image,
      _ItemType.file,
      _ItemType.link,
      _ItemType.audio,
    ][_selectedFilter];
    return _messages.where((m) => m.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17212B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Saved Messages',
                style: TextStyle(color: Colors.white, fontSize: 17)),
            Text('${_messages.length} messages',
                style: const TextStyle(
                    color: Color(0xFF7F91A4), fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(child: _buildList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2AABEE),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Type a note to save it here'),
                backgroundColor: Color(0xFF243447)),
          );
        },
        child: const Icon(Icons.edit_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 44,
      color: const Color(0xFF17212B),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        itemCount: _filters.length,
        itemBuilder: (_, i) {
          final selected = i == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF2AABEE)
                    : const Color(0xFF243447),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _filters[i],
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF7F91A4),
                  fontSize: 13,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList() {
    final items = _filtered;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bookmark_border_rounded,
                color: Color(0xFF7F91A4), size: 60),
            const SizedBox(height: 16),
            Text(
              'No ${_filters[_selectedFilter].toLowerCase()} saved yet',
              style: const TextStyle(
                  color: Color(0xFF7F91A4), fontSize: 15),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(
          color: Color(0xFF243447), height: 1),
      itemBuilder: (_, i) => _MessageTile(item: items[i]),
    );
  }
}

enum _ItemType { text, image, file, link, audio }

class _SavedItem {
  final _ItemType type;
  final String sender;
  final String text;
  final String time;

  const _SavedItem({
    required this.type,
    required this.sender,
    required this.text,
    required this.time,
  });
}

class _MessageTile extends StatelessWidget {
  final _SavedItem item;

  const _MessageTile({required this.item});

  IconData get _icon {
    switch (item.type) {
      case _ItemType.image:
        return Icons.image_outlined;
      case _ItemType.file:
        return Icons.insert_drive_file_outlined;
      case _ItemType.link:
        return Icons.link_rounded;
      case _ItemType.audio:
        return Icons.mic_rounded;
      default:
        return Icons.bookmark_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF2AABEE), Color(0xFF1E88D4)],
              ),
            ),
            alignment: Alignment.center,
            child:
                const Icon(Icons.bookmark_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Saved Messages',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Text(item.time,
                        style: const TextStyle(
                            color: Color(0xFF7F91A4), fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 4),
                if (item.type != _ItemType.text)
                  Row(
                    children: [
                      Icon(_icon,
                          color: const Color(0xFF2AABEE), size: 15),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.text,
                          style: const TextStyle(
                              color: Color(0xFF7F91A4), fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    item.text,
                    style: const TextStyle(
                        color: Color(0xFF7F91A4), fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
