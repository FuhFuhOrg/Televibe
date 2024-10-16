import 'package:flutter/material.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/Widgets/loginClass.dart';

class RegistrationVM {
  void navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void registerNewAccount(BuildContext context,
      TextEditingController mailController, TextEditingController loginController, TextEditingController passwordController, TextEditingController rePasswordController) {
    String mail = mailController.text;
    String login = loginController.text;
    String password = passwordController.text;
    String rePassword = rePasswordController.text;

    print('Mail: $mail');
    print('Login: $login');
    print('Password: $password');
    print('Re-Password: $rePassword');

    NetServerController().register(login, password).then((goin) {
      if (goin) {
        print('Return Registration');
      }
    });
  }
}
