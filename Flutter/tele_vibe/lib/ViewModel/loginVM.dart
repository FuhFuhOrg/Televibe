import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/Widgets/allChatsClass.dart';
import 'package:tele_vibe/Widgets/loginClass.dart';
import 'package:tele_vibe/Widgets/registrationClass.dart';

class LoginVM {
  late StreamSubscription<int> _chatsSubscription;

   LoginVM() {
    _chatsSubscription = Chats.onValueChanged.listen((value) {
      _handleChatsValueChanged(value);
    });
  }

  void dispose() {
    _chatsSubscription.cancel();
  }

  void navigateToRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  void fakeLoginAccount(BuildContext context, 
  TextEditingController loginController, TextEditingController passwordController) {
    String login = loginController.text;
    String password = passwordController.text;

    print('Login: $login');
    print('Password: $password');

    print('Return Login');
    _navigateToAllChats(context);
  }

  void loginAccount(BuildContext context, 
  TextEditingController loginController, TextEditingController passwordController) {
    String login = loginController.text;
    String password = passwordController.text;

    print('Login: $login');
    print('Password: $password');

    NetServerController().login(login, password).then((goin) {
      if (goin != " ") {
        print('Return Login');
      }
    });
  }

  void _handleChatsValueChanged(int value) {
    // Здесь вы можете выполнять действия при изменении переменной value
    print('Chats value changed: $value');
  }

  void _navigateToAllChats(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AllChatsPage()),
    );
  }
}