import 'package:flutter/widgets.dart';
import 'package:tele_vibe/Localization/app_language.dart';
import 'package:tele_vibe/Localization/locale_controller.dart';
import 'package:tele_vibe/Localization/locale_scope.dart';
import 'package:tele_vibe/l10n/generated/app_localizations.dart';

extension LocalizationBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  AppLocaleController get localeController => AppLocaleScope.of(this);

  AppLanguage get currentLanguage => localeController.language;
}