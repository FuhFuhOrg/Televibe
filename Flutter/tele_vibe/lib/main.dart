import 'package:flutter/material.dart';
import 'package:tele_vibe/Localization/locale_controller.dart';
import 'package:tele_vibe/Localization/locale_scope.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/Widgets/loginClass.dart';
import 'package:tele_vibe/Services/notification_service.dart';
import 'package:tele_vibe/l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация сервиса уведомлений
  final notificationService = NotificationService();
  await notificationService.init();
  final localeController = await AppLocaleController.create();

  NetServerController().start();
  runApp(MyApp(localeController: localeController));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.localeController});

  final AppLocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return AppLocaleScope(
      controller: localeController,
      child: AnimatedBuilder(
        animation: localeController,
        builder: (context, child) {
          return MaterialApp(
            title: 'Televibe',
            onGenerateTitle: (context) => AppLocalizations.of(context).appName,
            locale: localeController.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2AABEE),
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: const Color(0xFF0E1621),
              useMaterial3: true,
            ),
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}
