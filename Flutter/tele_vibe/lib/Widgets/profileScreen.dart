import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_vibe/Data/user.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart' as message_handler;
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/ViewModel/changeVeluesInProfileScreenVM.dart';
import 'package:tele_vibe/Widgets/settings.dart';

import 'UnderWidgets/fileUtils.dart';
import 'loginClass.dart';
import 'renameTextField.dart';

class ProfileScreen extends StatefulWidget {
  final String nickname;

  const ProfileScreen({super.key, required this.nickname});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nickname = '';
  String _username = '';
  String _bio = 'Hey there! I\'m using Televibe рџ‘‹';
  String? _profileImagePath;
  bool _notifyMessages = true;
  bool _notifySound = true;
  bool _notifyPreview = true;
  bool _autoDownload = true;
  bool _saveToGallery = false;
  String _privacyLastSeen = 'Everybody';
  String _privacyPhoto = 'Everybody';
  String _privacyForwards = 'Everybody';
  String _privacyCalls = 'My Contacts';

  final ChangeVeluesInProfileScreenVM changeProfileScreenVM =
      ChangeVeluesInProfileScreenVM();
  late Future<void> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _nickname = prefs.getString('nickname') ??
        (widget.nickname.isNotEmpty
            ? widget.nickname
            : (Anon.anonIdGet?.toString() ?? 'Unknown'));
    _username = prefs.getString('username') ?? Anon.username;
    _bio = prefs.getString('bio') ?? 'Hey there! I\'m using Televibe рџ‘‹';
    _profileImagePath = prefs.getString('profileImagePath');
    if (_profileImagePath != null && File(_profileImagePath!).existsSync()) {
      Anon.image = Image.file(File(_profileImagePath!), fit: BoxFit.cover);
    }
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nickname', _nickname);
    await prefs.setString('username', _username);
    await prefs.setString('bio', _bio);
    if (_profileImagePath != null) {
      await prefs.setString('profileImagePath', _profileImagePath!);
    } else {
      await prefs.remove('profileImagePath');
    }
  }

  void _navigateToEditScreen(
      String title, String currentText, Function(String) onSave) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RenameTextField(title: title, currentText: currentText),
      ),
    );
    if (!mounted) return;
    if (result != null) {
      onSave(result);
      _saveProfile();
      setState(() {});
    }
  }

  DecorationImage _buildProfileImage() {
    if (_profileImagePath != null && File(_profileImagePath!).existsSync()) {
      return DecorationImage(
        image: FileImage(File(_profileImagePath!)),
        fit: BoxFit.cover,
      );
    }
    return DecorationImage(image: Anon.image.image, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Color(0xFF0E1621),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userId = Anon.anonIdGet?.toString() ?? 'Unknown';
        final l10n = context.l10n;

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
                        decoration:
                            BoxDecoration(image: _buildProfileImage()),
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
                                  Text(
                                    'online',
                                    style: const TextStyle(
                                      color: Color(0xFF4CC38A),
                                      fontSize: 13,
                                    ),
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
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: Colors.white),
                    onPressed: () {
                      _navigateToEditScreen(
                          l10n.displayNameField, _nickname, (v) {
                        setState(() {
                          _nickname = v;
                          changeProfileScreenVM.changeUsername(v);
                        });
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert_rounded,
                        color: Colors.white),
                    onPressed: () => _showProfileOptions(context),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // в”Ђв”Ђ Quick actions в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                      Row(
                        children: [
                          _ActionButton(
                            icon: Icons.qr_code_rounded,
                            label: 'QR Code',
                            onTap: () => _showQrDialog(context),
                          ),
                          const SizedBox(width: 12),
                          _ActionButton(
                            icon: Icons.share_rounded,
                            label: 'Share',
                            onTap: () => _showShareSheet(context),
                          ),
                          const SizedBox(width: 12),
                          _ActionButton(
                            icon: Icons.link_rounded,
                            label: 'Copy Link',
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                  text: 'https://t.me/$_username'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Link copied'),
                                    backgroundColor: Color(0xFF243447)),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // в”Ђв”Ђ Account в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                      _InfoCard(
                        title: l10n.accountSectionTitle,
                        children: [
                          _ProfileRow(
                            label: 'Bio',
                            value: _bio,
                            trailing: const Icon(Icons.edit_outlined,
                                color: Color(0xFF7F91A4), size: 18),
                            onTap: () => _navigateToEditScreen(
                                'Edit Bio', _bio, (v) => _bio = v),
                          ),
                          _ProfileRow(
                            label: 'Phone',
                            value: '+1 (555) 000-0000',
                            trailing: const Icon(Icons.lock_outline_rounded,
                                color: Color(0xFF7F91A4), size: 16),
                          ),
                          _ProfileRow(
                            label: l10n.usernameLabel,
                            value: '@$_username',
                            trailing: const Icon(Icons.edit_outlined,
                                color: Color(0xFF7F91A4), size: 18),
                            onTap: () {
                              _navigateToEditScreen(
                                  l10n.usernameField, _username, (v) {
                                setState(() {
                                  _username = v;
                                  changeProfileScreenVM.changeUsername(v);
                                });
                              });
                            },
                          ),
                          _ProfileRow(
                            label: l10n.userIdLabel,
                            value: userId,
                            trailing: const Icon(Icons.copy_rounded,
                                color: Color(0xFF7F91A4), size: 18),
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: userId));
                              message_handler.MessageHandler.showAlertDialog(
                                  context, l10n.userIdCopied);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // в”Ђв”Ђ Privacy & Security в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                      _InfoCard(
                        title: 'Privacy & Security',
                        children: [
                          _PrivacySelectorRow(
                            label: 'Last Seen & Online',
                            value: _privacyLastSeen,
                            onChanged: (v) =>
                                setState(() => _privacyLastSeen = v),
                          ),
                          _PrivacySelectorRow(
                            label: 'Profile Photo',
                            value: _privacyPhoto,
                            onChanged: (v) =>
                                setState(() => _privacyPhoto = v),
                          ),
                          _PrivacySelectorRow(
                            label: 'Forwarded Messages',
                            value: _privacyForwards,
                            onChanged: (v) =>
                                setState(() => _privacyForwards = v),
                          ),
                          _PrivacySelectorRow(
                            label: 'Calls',
                            value: _privacyCalls,
                            onChanged: (v) =>
                                setState(() => _privacyCalls = v),
                          ),
                          _ProfileToggle(
                            label: 'Two-Step Verification',
                            subtitle: 'Add a password to log in',
                            value: false,
                            onChanged: (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('2FA setup coming soon'),
                                    backgroundColor: Color(0xFF243447)),
                              );
                            },
                          ),
                          _ProfileToggle(
                            label: 'Passcode Lock',
                            subtitle: 'Lock the app with a PIN',
                            value: false,
                            onChanged: (_) {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // в”Ђв”Ђ Notifications в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                      _InfoCard(
                        title: 'Notifications',
                        children: [
                          _ProfileToggle(
                            label: 'Message Notifications',
                            value: _notifyMessages,
                            onChanged: (v) =>
                                setState(() => _notifyMessages = v),
                          ),
                          _ProfileToggle(
                            label: 'Sound',
                            value: _notifySound,
                            onChanged: (v) =>
                                setState(() => _notifySound = v),
                          ),
                          _ProfileToggle(
                            label: 'Show Preview',
                            value: _notifyPreview,
                            onChanged: (v) =>
                                setState(() => _notifyPreview = v),
                          ),
                          _ProfileRow(
                            label: 'Notification Sound',
                            value: 'Default',
                            trailing: const Icon(Icons.chevron_right_rounded,
                                color: Color(0xFF7F91A4)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // в”Ђв”Ђ Appearance в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                      _InfoCard(
                        title: 'Appearance',
                        children: [
                          _ProfileToggle(
                            label: 'Dark Mode',
                            value: true,
                            onChanged: (_) {},
                          ),
                          _ProfileRow(
                            label: 'Language',
                            value: 'System default',
                            trailing: const Icon(Icons.chevron_right_rounded,
                                color: Color(0xFF7F91A4)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Settings()),
                              );
                            },
                          ),
                          _ProfileRow(
                            label: 'Font Size',
                            value: 'Normal',
                            trailing: const Icon(Icons.chevron_right_rounded,
                                color: Color(0xFF7F91A4)),
                          ),
                          _ProfileRow(
                            label: 'Chat Wallpaper',
                            value: 'Default',
                            trailing: const Icon(Icons.chevron_right_rounded,
                                color: Color(0xFF7F91A4)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // в”Ђв”Ђ Linked Devices в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                      _InfoCard(
                        title: 'Linked Devices',
                        children: [
                          _DeviceTile(
                            icon: Icons.web_rounded,
                            name: 'Televibe Web',
                            detail: 'Chrome В· 192.168.1.10',
                            activity: 'Active 2 min ago',
                          ),
                          _DeviceTile(
                            icon: Icons.desktop_windows_rounded,
                            name: 'Televibe Desktop',
                            detail: 'Windows 11 В· 192.168.1.5',
                            activity: 'Active 1 hour ago',
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.add_circle_outline_rounded,
                                color: Color(0xFF2AABEE)),
                            title: const Text('Link New Device',
                                style: TextStyle(color: Color(0xFF2AABEE))),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Scan QR code on another device'),
                                    backgroundColor: Color(0xFF243447)),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // в”Ђв”Ђ Active Sessions в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                      _InfoCard(
                        title: 'Active Sessions',
                        children: [
                          _SessionTile(
                            icon: Icons.phone_android_rounded,
                            name: 'Android В· Current',
                            location: 'Authenticated device',
                            badge: 'This device',
                            badgeColor: const Color(0xFF4CC38A),
                            canTerminate: false,
                          ),
                          _SessionTile(
                            icon: Icons.phone_iphone_rounded,
                            name: 'iPhone 15 Pro',
                            location: 'iOS 17 В· 3 days ago',
                            badge: null,
                            badgeColor: null,
                            canTerminate: true,
                          ),
                          _SessionTile(
                            icon: Icons.laptop_rounded,
                            name: 'MacBook Air',
                            location: 'macOS Sonoma В· 1 week ago',
                            badge: null,
                            badgeColor: null,
                            canTerminate: true,
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.logout_rounded,
                                color: Color(0xFFE57373)),
                            title: const Text('Terminate Other Sessions',
                                style: TextStyle(color: Color(0xFFE57373))),
                            onTap: () => _confirmTerminateSessions(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // в”Ђв”Ђ Data & Storage в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
                      _InfoCard(
                        title: 'Data & Storage',
                        children: [
                          _ProfileToggle(
                            label: 'Auto-Download Media',
                            subtitle: 'Wi-Fi & mobile data',
                            value: _autoDownload,
                            onChanged: (v) =>
                                setState(() => _autoDownload = v),
                          ),
                          _ProfileToggle(
                            label: 'Save Photos to Gallery',
                            value: _saveToGallery,
                            onChanged: (v) =>
                                setState(() => _saveToGallery = v),
                          ),
                          _ProfileRow(
                            label: 'Storage Used',
                            value: '1.2 GB',
                            trailing: const Icon(Icons.chevron_right_rounded,
                                color: Color(0xFF7F91A4)),
                          ),
                          _ProfileRow(
                            label: 'Clear Cache',
                            value: '156 MB',
                            trailing: const Icon(Icons.delete_outline_rounded,
                                color: Color(0xFF7F91A4), size: 18),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Cache cleared'),
                                    backgroundColor: Color(0xFF243447)),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // в”Ђв”Ђ Danger Zone в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
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
                              leading: const Icon(Icons.logout_rounded,
                                  color: Color(0xFFE57373)),
                              title: const Text('Log Out',
                                  style: TextStyle(color: Color(0xFFE57373))),
                              onTap: () => _confirmLogOut(context),
                            ),
                            const Divider(
                                height: 1, color: Color(0xFF3D2020)),
                            ListTile(
                              leading: const Icon(Icons.delete_forever_rounded,
                                  color: Color(0xFFE53935)),
                              title: const Text('Delete Account',
                                  style: TextStyle(
                                      color: Color(0xFFE53935),
                                      fontWeight: FontWeight.w600)),
                              onTap: () => _confirmDeleteAccount(context),
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
      },
    );
  }

  void _showQrDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF17212B),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('QR Code',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.qr_code_2_rounded,
                  size: 140, color: Color(0xFF0E1621)),
            ),
            const SizedBox(height: 12),
            Text('@$_username',
                style: const TextStyle(
                    color: Colors.white70, fontSize: 14)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close',
                style: TextStyle(color: Color(0xFF2AABEE))),
          ),
        ],
      ),
    );
  }

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17212B),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text('Share Profile',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('https://t.me/$_username',
                style: const TextStyle(
                    color: Color(0xFF7F91A4), fontSize: 13)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.copy_rounded,
                  color: Color(0xFF7F91A4)),
              title: const Text('Copy Link',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(
                    ClipboardData(text: 'https://t.me/$_username'));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Link copied'),
                      backgroundColor: Color(0xFF243447)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_rounded,
                  color: Color(0xFF7F91A4)),
              title: const Text('Share viaвЂ¦',
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmTerminateSessions(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF17212B),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Terminate Sessions',
            style: TextStyle(color: Colors.white)),
        content: const Text(
            'All other active sessions will be logged out.',
            style: TextStyle(color: Color(0xFF7F91A4))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF7F91A4))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Other sessions terminated'),
                    backgroundColor: Color(0xFF243447)),
              );
            },
            child: const Text('Terminate',
                style: TextStyle(color: Color(0xFFE57373))),
          ),
        ],
      ),
    );
  }

  void _confirmLogOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF17212B),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out',
            style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to log out?',
            style: TextStyle(color: Color(0xFF7F91A4))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF7F91A4))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
            child: const Text('Log Out',
                style: TextStyle(color: Color(0xFFE57373))),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF17212B),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Account',
            style: TextStyle(
                color: Color(0xFFE53935), fontWeight: FontWeight.w700)),
        content: const Text(
            'This will permanently delete your account, all messages and data. This action cannot be undone.',
            style: TextStyle(color: Color(0xFF7F91A4))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF7F91A4))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Delete',
                style: TextStyle(
                    color: Color(0xFFE53935),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showProfileOptions(BuildContext context) {
    final l10n = context.l10n;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17212B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_rounded,
                    color: Colors.white),
                title: Text(l10n.addPhoto,
                    style: const TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImage = await FileUtils.pickImage();
                  if (pickedImage != null) {
                    setState(() => _profileImagePath = pickedImage.path);
                    _saveProfile();
                  } else {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.imageNotSelected,
                            style: const TextStyle(color: Colors.white)),
                        backgroundColor: const Color(0xFF222222),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFFE57373)),
                title: Text(l10n.removePhoto,
                    style: const TextStyle(color: Color(0xFFE57373))),
                onTap: () async {
                  Navigator.pop(context);
                  setState(() => _profileImagePath = null);
                  await _saveProfile();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ
// Helper widgets
// в”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђв”Ђ

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
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
                  style: const TextStyle(
                      color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({required this.title, required this.children});

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

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileRow({
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

class _ProfileToggle extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ProfileToggle({
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: const TextStyle(color: Color(0xFF7F91A4), fontSize: 12))
          : null,
      value: value,
      activeColor: const Color(0xFF2AABEE),
      onChanged: onChanged,
    );
  }
}

class _PrivacySelectorRow extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _PrivacySelectorRow(
      {required this.label, required this.value, required this.onChanged});

  static const _options = ['Everybody', 'My Contacts', 'Nobody'];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: const TextStyle(color: Color(0xFF7F91A4), fontSize: 13)),
          const Icon(Icons.chevron_right_rounded,
              color: Color(0xFF7F91A4), size: 18),
        ],
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFF17212B),
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(18))),
          builder: (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                ),
                ..._options.map(
                  (opt) => RadioListTile<String>(
                    title: Text(opt,
                        style: const TextStyle(color: Colors.white)),
                    value: opt,
                    groupValue: value,
                    activeColor: const Color(0xFF2AABEE),
                    onChanged: (v) {
                      Navigator.pop(context);
                      if (v != null) onChanged(v);
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DeviceTile extends StatelessWidget {
  final IconData icon;
  final String name;
  final String detail;
  final String activity;

  const _DeviceTile({
    required this.icon,
    required this.name,
    required this.detail,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFF243447),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF2AABEE), size: 22),
      ),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      subtitle: Text('$detail\n$activity',
          style:
              const TextStyle(color: Color(0xFF7F91A4), fontSize: 12, height: 1.4)),
      isThreeLine: true,
    );
  }
}

class _SessionTile extends StatelessWidget {
  final IconData icon;
  final String name;
  final String location;
  final String? badge;
  final Color? badgeColor;
  final bool canTerminate;

  const _SessionTile({
    required this.icon,
    required this.name,
    required this.location,
    required this.badge,
    required this.badgeColor,
    required this.canTerminate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFF243447),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF2AABEE), size: 22),
      ),
      title: Row(
        children: [
          Text(name, style: const TextStyle(color: Colors.white)),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor!.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(badge!,
                  style: TextStyle(
                      color: badgeColor!, fontSize: 10)),
            ),
          ]
        ],
      ),
      subtitle: Text(location,
          style: const TextStyle(color: Color(0xFF7F91A4), fontSize: 12)),
      trailing: canTerminate
          ? IconButton(
              icon: const Icon(Icons.close_rounded,
                  color: Color(0xFF7F91A4), size: 18),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('$name terminated'),
                      backgroundColor: const Color(0xFF243447)),
                );
              },
            )
          : null,
    );
  }
}

