import 'package:flutter/material.dart';

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  static final _recommended = [
    _ChannelData(
      name: 'Flutter Dev Updates',
      category: 'Tech',
      subscribers: '1.2M',
      lastPost: '2 min ago',
    ),
    _ChannelData(
      name: 'Design Inspo Daily',
      category: 'Design',
      subscribers: '845K',
      lastPost: '1 hr ago',
    ),
    _ChannelData(
      name: 'Product Hunt',
      category: 'Startups',
      subscribers: '3.1M',
      lastPost: '5 min ago',
    ),
    _ChannelData(
      name: 'Crypto Signals',
      category: 'Finance',
      subscribers: '520K',
      lastPost: '30 min ago',
    ),
    _ChannelData(
      name: 'Morning Brew',
      category: 'News',
      subscribers: '2.4M',
      lastPost: '8 hr ago',
    ),
    _ChannelData(
      name: 'Indie Hackers',
      category: 'Business',
      subscribers: '210K',
      lastPost: 'Yesterday',
    ),
  ];

  final Set<String> _subscribed = {'Flutter Dev Updates'};

  List<_ChannelData> get _filtered {
    if (_query.isEmpty) return _recommended;
    return _recommended
        .where((c) =>
            c.name.toLowerCase().contains(_query.toLowerCase()) ||
            c.category.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
        title: const Text('Channels',
            style: TextStyle(color: Colors.white, fontSize: 17)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Create channel coming soon'),
                    backgroundColor: Color(0xFF243447)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: ListView(
              children: [
                if (_subscribed.isNotEmpty) ...[
                  _buildSectionHeader('Your Channels'),
                  ..._recommended
                      .where((c) => _subscribed.contains(c.name))
                      .map((c) => _ChannelTile(
                            data: c,
                            isSubscribed: true,
                            onToggle: () => setState(
                                () => _subscribed.remove(c.name)),
                          )),
                ],
                _buildSectionHeader('Recommended'),
                if (_filtered.isEmpty)
                  _buildEmpty()
                else
                  ..._filtered.map((c) => _ChannelTile(
                        data: c,
                        isSubscribed: _subscribed.contains(c.name),
                        onToggle: () => setState(() {
                          if (_subscribed.contains(c.name)) {
                            _subscribed.remove(c.name);
                          } else {
                            _subscribed.add(c.name);
                          }
                        }),
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF17212B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF243447)),
        ),
        child: TextField(
          controller: _searchCtrl,
          style: const TextStyle(color: Colors.white),
          onChanged: (v) => setState(() => _query = v),
          decoration: const InputDecoration(
            hintText: 'Search channels…',
            hintStyle: TextStyle(color: Color(0xFF7F91A4)),
            prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF7F91A4)),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
            color: Color(0xFF2AABEE),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.campaign_outlined,
                color: Color(0xFF7F91A4), size: 56),
            const SizedBox(height: 12),
            const Text('No channels found',
                style: TextStyle(color: Color(0xFF7F91A4))),
          ],
        ),
      ),
    );
  }
}

class _ChannelData {
  final String name;
  final String category;
  final String subscribers;
  final String lastPost;

  const _ChannelData({
    required this.name,
    required this.category,
    required this.subscribers,
    required this.lastPost,
  });
}

class _ChannelTile extends StatelessWidget {
  final _ChannelData data;
  final bool isSubscribed;
  final VoidCallback onToggle;

  const _ChannelTile({
    required this.data,
    required this.isSubscribed,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final initials = data.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF2AABEE), Color(0xFF1E7AC5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: Text(initials,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      title: Text(data.name,
          style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        '${data.subscribers} subscribers • ${data.lastPost}',
        style:
            const TextStyle(color: Color(0xFF7F91A4), fontSize: 12),
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: isSubscribed
                    ? const Color(0xFF243447)
                    : const Color(0xFF2AABEE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isSubscribed ? 'Subscribed' : 'Subscribe',
                style: TextStyle(
                  color: isSubscribed
                      ? const Color(0xFF7F91A4)
                      : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF243447),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(data.category,
                style: const TextStyle(
                    color: Color(0xFF7F91A4), fontSize: 10)),
          ),
        ],
      ),
    );
  }
}
