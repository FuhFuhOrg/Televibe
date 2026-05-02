import 'package:flutter/material.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/ViewModel/SettingsVM.dart';
import 'package:tele_vibe/Widgets/LanguageSettings.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool _notifications;
  late bool _sound;
  final SettingsVM _settingsVM = SettingsVM();

  @override
  void initState() {
    super.initState();
    _notifications = _settingsVM.getNotifications();
    _sound = _settingsVM.getVolume();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17212B),
        title: Text(
          l10n.settingsTitle,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF17212B),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF243447)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.controlYourExperienceTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.controlYourExperienceDescription,
                  style: const TextStyle(
                    color: Color(0xFF7F91A4),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SettingsCard(
            title: l10n.notificationsAndSound,
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: const Color(0xFF2AABEE),
                  title: Text(
                    l10n.messageNotificationsTitle,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    l10n.messageNotificationsDescription,
                    style: const TextStyle(color: Color(0xFF7F91A4)),
                  ),
                  value: _notifications,
                  onChanged: (bool value) {
                    setState(() {
                      _settingsVM.changeNotifications(value);
                      _notifications = value;
                    });
                  },
                ),
                const Divider(color: Color(0xFF243447), height: 1),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: const Color(0xFF2AABEE),
                  title: Text(
                    l10n.soundTitle,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    l10n.soundDescription,
                    style: const TextStyle(color: Color(0xFF7F91A4)),
                  ),
                  value: _sound,
                  onChanged: (bool value) {
                    setState(() {
                      _settingsVM.changeVolume(value);
                      _sound = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SettingsCard(
            title: l10n.interfaceTitle,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading:
                  const Icon(Icons.language_rounded, color: Color(0xFF2AABEE)),
              title: Text(
                l10n.languageTitle,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                l10n.reviewLanguageOptions,
                style: const TextStyle(color: Color(0xFF7F91A4)),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF7F91A4),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageSettings(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          _SettingsCard(
            title: l10n.navigationTitle,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF2AABEE),
              ),
              title: Text(
                l10n.backToChats,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                l10n.backToChatsDescription,
                style: const TextStyle(color: Color(0xFF7F91A4)),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF7F91A4),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
