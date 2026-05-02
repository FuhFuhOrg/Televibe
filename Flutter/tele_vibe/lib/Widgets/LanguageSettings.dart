import 'package:flutter/material.dart';
import 'package:tele_vibe/Localization/app_language.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';

class LanguageSettings extends StatelessWidget {
  const LanguageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedLanguage = context.currentLanguage;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      appBar: AppBar(
        title: Text(l10n.languageTitle,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF17212B),
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
            child: Text(
              l10n.languageSettingsDescription,
              style: const TextStyle(
                color: Color(0xFF7F91A4),
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(height: 14),
          for (final language in AppLanguage.values) ...[
            _LanguageOption(
              title: language.nativeName,
              subtitle: selectedLanguage == language
                  ? l10n.selectedLanguageDescription
                  : l10n.tapToSwitchLanguageDescription,
              selected: selectedLanguage == language,
              onTap: () async {
                await context.localeController.setLanguage(language);
              },
            ),
            if (language != AppLanguage.values.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final Future<void> Function() onTap;

  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF17212B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? const Color(0xFF2AABEE) : const Color(0xFF243447),
        ),
      ),
      child: ListTile(
        leading: Icon(
          selected ? Icons.check_circle_rounded : Icons.language_rounded,
          color: selected ? const Color(0xFF2AABEE) : const Color(0xFF7F91A4),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF7F91A4)),
        ),
        onTap: () async {
          await onTap();
        },
      ),
    );
  }
}
