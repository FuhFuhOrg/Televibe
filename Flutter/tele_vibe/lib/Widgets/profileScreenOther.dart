import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart' as message_handler;
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/ViewModel/otherManVM.dart';

class ProfileScreenOther extends StatefulWidget {
  final String nickname;
  final int userID;
  final Image? image;

  const ProfileScreenOther(
      {super.key,
      required this.nickname,
      required this.userID,
      required this.image});

  @override
  State<ProfileScreenOther> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreenOther> {
  String _nickname;
  late int _userID;
  Image? _image;
  bool _isMuted = false;
  final OtherManVM _chatListVM = OtherManVM();

  _ProfileScreenState() : _nickname = '';

  @override
  void initState() {
    super.initState();
    _nickname = widget.nickname;
    _userID = widget.userID;
    _image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final username = _chatListVM.getUsername(_userID);
    final bio = _chatListVM.getInfoAboutMe(_userID);

    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: const Color(0xFF17212B),
            expandedHeight: MediaQuery.of(context).size.height * 0.38,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF223244),
                      image: _image != null
                          ? DecorationImage(
                              image: _image!.image,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: _image == null
                        ? const Icon(Icons.person_rounded,
                            color: Colors.white, size: 84)
                        : null,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0x00000000), Color(0xCC0E1621)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _nickname,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.circle,
                                  color: Color(0xFF4CC38A), size: 9),
                              const SizedBox(width: 5),
                              const Text(
                                'online',
                                style: TextStyle(
                                    color: Color(0xFF4CC38A), fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              collapseMode: CollapseMode.parallax,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                onPressed: () => _showMoreOptions(context),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // в”Ђв”Ђ Action buttons в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                  Row(
                    children: [
                      _OtherActionButton(
                        icon: Icons.message_rounded,
                        label: 'Message',
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      _OtherActionButton(
                        icon: Icons.call_rounded,
                        label: 'Call',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('CallingвЂ¦'),
                                backgroundColor: Color(0xFF243447)),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      _OtherActionButton(
                        icon: Icons.videocam_rounded,
                        label: 'Video',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Video callвЂ¦'),
                                backgroundColor: Color(0xFF243447)),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      _OtherActionButton(
                        icon: _isMuted
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded,
                        label: _isMuted ? 'Unmute' : 'Mute',
                        onTap: () => setState(() => _isMuted = !_isMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // в”Ђв”Ђ Info в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                  _OtherInfoCard(
                    title: 'Info',
                    children: [
                      if (bio.isNotEmpty)
                        _OtherProfileRow(label: 'About', value: bio),
                      _OtherProfileRow(
                          label: 'Phone', value: '+1 (555) 000-0000'),
                      _OtherProfileRow(
                          label: l10n.usernameLabel, value: '@$username'),
                      _OtherProfileRow(
                        label: l10n.userIdLabel,
                        value: _userID.toString(),
                        trailing: const Icon(Icons.copy_rounded,
                            color: Color(0xFF7F91A4), size: 18),
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: _userID.toString()));
                          message_handler.MessageHandler.showAlertDialog(
                              context, l10n.userIdCopied);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // в”Ђв”Ђ Shared Media в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                  _OtherInfoCard(
                    title: 'Shared Media (23)',
                    children: [
                      Row(
                        children: [
                          _MediaThumb(color: const Color(0xFF243447),
                              icon: Icons.image_outlined),
                          const SizedBox(width: 6),
                          _MediaThumb(color: const Color(0xFF1D2E3F),
                              icon: Icons.play_circle_outline_rounded),
                          const SizedBox(width: 6),
                          _MediaThumb(color: const Color(0xFF22303F),
                              icon: Icons.image_outlined),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text('View All',
                                style: TextStyle(color: Color(0xFF2AABEE))),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // в”Ђв”Ђ Common Groups в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                  _OtherInfoCard(
                    title: 'Groups in Common (2)',
                    children: [
                      _CommonGroupTile(
                        name: 'Product Team',
                        members: '14 members',
                      ),
                      _CommonGroupTile(
                        name: 'Design Review',
                        members: '8 members',
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // в”Ђв”Ђ Notifications в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                  _OtherInfoCard(
                    title: 'Notifications',
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Mute',
                            style: TextStyle(color: Colors.white)),
                        subtitle: const Text('Disable all notifications',
                            style: TextStyle(
                                color: Color(0xFF7F91A4), fontSize: 12)),
                        value: _isMuted,
                        activeColor: const Color(0xFF2AABEE),
                        onChanged: (v) => setState(() => _isMuted = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // в”Ђв”Ђ Actions в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF17212B),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF3D2020)),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.block_rounded,
                              color: Color(0xFFE57373)),
                          title: Text('Block ${_nickname}',
                              style: const TextStyle(
                                  color: Color(0xFFE57373))),
                          onTap: () => _confirmBlock(context),
                        ),
                        const Divider(height: 1, color: Color(0xFF3D2020)),
                        ListTile(
                          leading: const Icon(Icons.flag_rounded,
                              color: Color(0xFFE53935)),
                          title: Text('Report ${_nickname}',
                              style: const TextStyle(
                                  color: Color(0xFFE53935),
                                  fontWeight: FontWeight.w600)),
                          onTap: () => _showReportSheet(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17212B),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.copy_rounded, color: Color(0xFF7F91A4)),
              title: Text(l10n.userIdCopied,
                  style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: _userID.toString()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt_1_rounded,
                  color: Color(0xFF7F91A4)),
              title: const Text('Add to Contacts',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Added to contacts'),
                      backgroundColor: Color(0xFF243447)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_rounded,
                  color: Color(0xFF7F91A4)),
              title: const Text('Share Contact',
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmBlock(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF17212B),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Block $_nickname',
            style: const TextStyle(color: Colors.white)),
        content: Text(
            '$_nickname will no longer be able to message you.',
            style: const TextStyle(color: Color(0xFF7F91A4))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF7F91A4))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Block',
                style: TextStyle(color: Color(0xFFE57373))),
          ),
        ],
      ),
    );
  }

  void _showReportSheet(BuildContext context) {
    const reasons = [
      'Spam',
      'Fake account',
      'Inappropriate content',
      'Harassment',
      'Other',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17212B),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Report',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700)),
            ),
            ...reasons.map(
              (r) => ListTile(
                title: Text(r,
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Report sent: $r'),
                        backgroundColor: const Color(0xFF243447)),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
// Helper widgets
// в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ

class _OtherActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OtherActionButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF17212B),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF243447)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF2AABEE), size: 22),
              const SizedBox(height: 5),
              Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtherInfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _OtherInfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF17212B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF243447)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _OtherProfileRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _OtherProfileRow({
    required this.label,
    required this.value,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(color: Colors.white)),
      subtitle:
          Text(value, style: const TextStyle(color: Color(0xFF7F91A4))),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _MediaThumb extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _MediaThumb({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: const Color(0xFF7F91A4), size: 28),
    );
  }
}

class _CommonGroupTile extends StatelessWidget {
  final String name;
  final String members;

  const _CommonGroupTile({required this.name, required this.members});

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();
    final colors = [
      [const Color(0xFF37AEE2), const Color(0xFF1E96C8)],
      [const Color(0xFF8E7CF6), const Color(0xFF4C6FFF)],
    ];
    final idx = name.codeUnits.fold<int>(0, (s, c) => s + c) % colors.length;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: colors[idx],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        alignment: Alignment.center,
        child: Text(initials,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      subtitle: Text(members,
          style: const TextStyle(color: Color(0xFF7F91A4), fontSize: 12)),
    );
  }
}

