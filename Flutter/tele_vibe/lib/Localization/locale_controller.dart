import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_vibe/Localization/app_language.dart';

class AppLocaleController extends ChangeNotifier {
  AppLocaleController._(this._language);

  static const String _storageKey = 'app.language.code';

  AppLanguage _language;

  AppLanguage get language => _language;
  Locale get locale => _language.locale;

  static Future<AppLocaleController> create() async {
    final preferences = await SharedPreferences.getInstance();
    final savedCode = preferences.getString(_storageKey);
    final language =
        AppLanguage.fromCode(savedCode) ?? AppLanguage.resolve(PlatformDispatcher.instance.locale);
    return AppLocaleController._(language);
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_language == language) {
      return;
    }

    _language = language;
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, language.code);
  }
}