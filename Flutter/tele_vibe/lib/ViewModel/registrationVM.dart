import 'package:flutter/material.dart';
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

  void registerNewAccount(BuildContext context,
      //TextEditingController mailController, 
      TextEditingController loginController, TextEditingController passwordController, TextEditingController rePasswordController) {
    //String mail = mailController.text;
    String login = loginController.text;
    String password = passwordController.text;
    String rePassword = rePasswordController.text;

    //print('Mail: $mail');
    print('Login: $login');
    print('Password: $password');
    print('Re-Password: $rePassword');

    if (password == rePassword){
      NetServerController().register(login, password).then((goin) {
        if (goin[0] == "true") {
          print('Return Registration');
          LoginVM().loginAccount(context, loginController, passwordController);
        }
        else{
          MessageHandler.showAlertDialog(context, '${goin.join(" ")}');
        }
      });
    }
    else{
          MessageHandler.showAlertDialog(context, 'У вас не совпадает пароль');
    }
  }
}
