import 'package:flutter/material.dart';

import 'UnderWidgets/telegramAvatar.dart';

class NearbyPeopleScreen extends StatefulWidget {
  const NearbyPeopleScreen({super.key});

  @override
  State<NearbyPeopleScreen> createState() => _NearbyPeopleScreenState();
}

class _NearbyPeopleScreenState extends State<NearbyPeopleScreen> {
  bool _isVisible = false;

  static final _people = [
    _NearbyUser(name: 'Alice Harper', distance: '0.1 km', mutual: 3),
    _NearbyUser(name: 'James Liu', distance: '0.3 km', mutual: 0),
    _NearbyUser(name: 'Sofia Müller', distance: '0.7 km', mutual: 1),
    _NearbyUser(name: 'Ravi Shankar', distance: '1.2 km', mutual: 5),
    _NearbyUser(name: 'Mia Johansson', distance: '2.0 km', mutual: 2),
  ];

  final Set<String> _added = {};

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
        title: const Text('Find People',
            style: TextStyle(color: Colors.white, fontSize: 17)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_search_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Search by username'),
                    backgroundColor: Color(0xFF243447)),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // ── Visibility toggle ────────────────────────────────────────
          SwitchListTile(
            tileColor: const Color(0xFF17212B),
            title: const Text('Make myself visible',
                style: TextStyle(color: Colors.white)),
            subtitle: Text(
              _isVisible
                  ? 'Other users nearby can see you'
                  : 'You are hidden from nearby search',
              style: const TextStyle(color: Color(0xFF7F91A4), fontSize: 12),
            ),
            secondary: Icon(
              _isVisible ? Icons.location_on_rounded : Icons.location_off_rounded,
              color:
                  _isVisible ? const Color(0xFF2AABEE) : const Color(0xFF7F91A4),
            ),
            value: _isVisible,
            activeColor: const Color(0xFF2AABEE),
            onChanged: (v) => setState(() => _isVisible = v),
          ),
          const Divider(color: Color(0xFF243447), height: 1),

          // ── Map placeholder ──────────────────────────────────────────
          Container(
            margin: const EdgeInsets.all(16),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFF0D2540), Color(0xFF0E4060)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Decorative rings
                for (final size in [60.0, 100.0, 150.0])
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFF2AABEE).withValues(alpha: 0.2),
                          width: 1.5),
                    ),
                  ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on_rounded,
                        color: Color(0xFF2AABEE), size: 36),
                    const SizedBox(height: 8),
                    Text(
                      _isVisible
                          ? 'Searching nearby…'
                          : 'Enable visibility to see people nearby',
                      style: const TextStyle(
                          color: Color(0xFF7F91A4), fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── People nearby list ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 6),
            child: Text(
              _isVisible
                  ? 'People Nearby (${_people.length})'
                  : 'People Nearby',
              style: const TextStyle(
                  color: Color(0xFF2AABEE),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5),
            ),
          ),
          if (!_isVisible)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Enable "Make myself visible" to discover people nearby.',
                style: TextStyle(color: Color(0xFF7F91A4), fontSize: 13),
              ),
            )
          else
            ..._people.map((u) => _NearbyUserTile(
                  user: u,
                  added: _added.contains(u.name),
                  onAdd: () => setState(() => _added.add(u.name)),
                )),

          const Divider(color: Color(0xFF243447), height: 24),

          // ── Privacy note ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: Color(0xFF7F91A4), size: 16),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Your exact location is never shared. Only users who opt in are shown, and only their approximate distance is displayed.',
                    style: TextStyle(
                        color: Color(0xFF7F91A4),
                        fontSize: 12,
                        height: 1.45),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _NearbyUser {
  final String name;
  final String distance;
  final int mutual;

  const _NearbyUser({
    required this.name,
    required this.distance,
    required this.mutual,
  });
}

class _NearbyUserTile extends StatelessWidget {
  final _NearbyUser user;
  final bool added;
  final VoidCallback onAdd;

  const _NearbyUserTile({
    required this.user,
    required this.added,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: TelegramAvatar(imageUrl: null, title: user.name, isGroup: false),
      title: Text(user.name,
          style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        '${user.distance}${user.mutual > 0 ? ' • ${user.mutual} mutual' : ''}',
        style:
            const TextStyle(color: Color(0xFF7F91A4), fontSize: 12),
      ),
      trailing: GestureDetector(
        onTap: added ? null : onAdd,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: added
                ? const Color(0xFF243447)
                : const Color(0xFF2AABEE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            added ? 'Added' : 'Add',
            style: TextStyle(
              color:
                  added ? const Color(0xFF7F91A4) : Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
