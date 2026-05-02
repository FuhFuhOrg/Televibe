import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/Data/user.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart';
import 'package:tele_vibe/GettedData/localDataSaveController.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/GettedData/pseudoChatApi.dart';
import 'package:tele_vibe/Widgets/allChatsClass.dart';
import 'package:tele_vibe/Widgets/registrationClass.dart';

class LoginVM {
  void navigateToRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationPage()),
    );
  }

  // Проверка сохраненных учетных данных и автоматический вход
  Future<bool> tryAutoLogin(BuildContext context) async {
    var (login, password) = await LocalDataSave.loadCredentials();
    if (login != null && password != null) {
      debugPrint('Attempting auto sign-in: $login');
      List<String> goin = await NetServerController().login(
        login,
        password,
        timeout: const Duration(milliseconds: 1800),
      );

      if (goin.isNotEmpty && goin[0] == "true") {
        debugPrint('Auto sign-in succeeded');
        Anon.anonId = int.tryParse(goin[1]);
        Anon.anonPassword = password;
        _startChatsAddiction();
        if (!context.mounted) return false;
        _navigateToAllChats(context);
        return true;
      } else {
        debugPrint('Auto sign-in failed');
        await LocalDataSave.clearCredentials();
      }
    }
    if (!context.mounted) return false;
    await openPreparedChatsIfApiUnavailable(context);
    return false;
  }

  Future<void> openPreparedChatsIfApiUnavailable(BuildContext context) async {
    final isApiAvailable = await NetServerController().isApiAvailable();
    if (isApiAvailable || !context.mounted) return;
    await openPreparedChats(context);
  }

  Future<void> openPreparedChats(BuildContext context) async {
    await PseudoChatApi.activate();
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AllChatsPage()),
    );
  }

  void fakeLoginAccount(
      BuildContext context,
      TextEditingController loginController,
      TextEditingController passwordController) {
    String login = loginController.text;

    debugPrint('Login: $login');
    debugPrint('Return Login');

    _startChatsAddiction();
    _navigateToAllChats(context);
  }

  Future<void> loginAccount(
      BuildContext context,
      TextEditingController loginController,
      TextEditingController passwordController) async {
    String login = loginController.text;
    String password = passwordController.text;

    debugPrint('Login: $login');

    List<String> goin = await NetServerController().login(
      login,
      password,
      timeout: const Duration(milliseconds: 2200),
    );

    if (goin.isEmpty) {
      if (!context.mounted) return;
      await openPreparedChats(context);
      return;
    }

    if (goin.any((item) => item.trim().isNotEmpty)) {
      debugPrint('Return Login $goin');
      if (goin[0] == "true") {
        // Сохраняем учетные данные при успешном входе
        LocalDataSave.saveCredentials(login, password);

        Anon.anonId = int.tryParse(goin[1]);
        Anon.anonPassword = password;
        _startChatsAddiction();
        if (!context.mounted) return;
        _navigateToAllChats(context);
      } else {
        if (!context.mounted) return;
        MessageHandler.showAlertDialog(context, goin.join(" "));
      }
    }
  }

  void _startChatsAddiction() {
    // Код вызывающий подгрузку Json и WS чатов
    LocalDataSave.loadChatsData().then((goin) {
      if (goin != null) {
        Chats.setValue(goin);
      }
    });
  }

  void _navigateToAllChats(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllChatsPage()),
    );
  }
}
