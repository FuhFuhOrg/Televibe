import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/Widgets/allChatsClass.dart';
import 'package:tele_vibe/Widgets/loginClass.dart';
import 'package:tele_vibe/Widgets/registrationClass.dart';

class LoginVM extends StatelessWidget {
  late StreamSubscription<int> _chatsSubscription;

  @override
  void initState() {
    _chatsSubscription = Chats.onValueChanged.listen((value) {
      _handleChatsValueChanged(value);
    });
  }

  @override
  void dispose() {
    _chatsSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }

  void NavigateToRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  void falseLoginAccount(BuildContext context, 
  TextEditingController _loginController, TextEditingController _passwordController) {
    String login = _loginController.text;
    String password = _passwordController.text;

    print('Login: $login');
    print('Password: $password');

    print('Return Login');
    _navigateToAllChats(context);
  }

  void loginAccount(BuildContext context, 
  TextEditingController _loginController, TextEditingController _passwordController) {
    String login = _loginController.text;
    String password = _passwordController.text;

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