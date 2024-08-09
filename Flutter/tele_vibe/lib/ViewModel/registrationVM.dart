import 'package:flutter/material.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/Widgets/loginClass.dart';

class RegistrationVM {
  void navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void registerNewAccount(BuildContext context,
      TextEditingController _mailController, TextEditingController _loginController, TextEditingController _passwordController, TextEditingController _rePasswordController) {
    String mail = _mailController.text;
    String login = _loginController.text;
    String password = _passwordController.text;
    String rePassword = _rePasswordController.text;

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
