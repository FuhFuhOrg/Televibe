import 'package:flutter/material.dart';

enum AppLanguage {
  english(
    code: 'en',
    locale: Locale.fromSubtags(languageCode: 'en'),
    nativeName: 'English',
  ),
  russian(
    code: 'ru',
    locale: Locale.fromSubtags(languageCode: 'ru'),
    nativeName: 'Русский',
  ),
  german(
    code: 'de',
    locale: Locale.fromSubtags(languageCode: 'de'),
    nativeName: 'Deutsch',
  );

  const AppLanguage({
    required this.code,
    required this.locale,
    required this.nativeName,
  });

  final String code;
  final Locale locale;
  final String nativeName;

  static AppLanguage? fromCode(String? code) {
    for (final language in values) {
      if (language.code == code) {
        return language;
      }
    }
    return null;
  }

  static AppLanguage resolve(Locale? locale) {
    return fromCode(locale?.languageCode) ?? AppLanguage.english;
  }
}