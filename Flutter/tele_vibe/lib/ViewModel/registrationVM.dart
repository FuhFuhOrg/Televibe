import 'package:flutter/material.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/ViewModel/loginVM.dart';
import 'package:tele_vibe/Widgets/loginClass.dart';

class RegistrationVM {
  void navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void registerNewAccount(
      BuildContext context,
      //TextEditingController mailController,
      TextEditingController loginController,
      TextEditingController passwordController,
      TextEditingController rePasswordController) {
    //String mail = mailController.text;
    String login = loginController.text;
    String password = passwordController.text;
    String rePassword = rePasswordController.text;

    debugPrint('Login: $login');
    debugPrint(
        'Registration password fields entered: ${password.isNotEmpty && rePassword.isNotEmpty}');

    if (password == rePassword) {
      NetServerController().register(login, password).then((goin) {
        if (goin.isNotEmpty && goin[0] == "true") {
          debugPrint('Return Registration');
          if (!context.mounted) return;
          LoginVM().loginAccount(context, loginController, passwordController);
        } else {
          if (!context.mounted) return;
          MessageHandler.showAlertDialog(context, goin.join(" "));
        }
      });
    } else {
      if (!context.mounted) return;
      MessageHandler.showAlertDialog(context, context.l10n.passwordsDoNotMatch);
    }
  }
}
