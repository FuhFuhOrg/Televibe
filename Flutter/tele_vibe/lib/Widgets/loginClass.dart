import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/Widgets/allChatsClass.dart';
import 'package:tele_vibe/Widgets/registrationClass.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginClassState createState() => _LoginClassState();
}

class _LoginClassState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late StreamSubscription<int> _chatsSubscription;

  @override
  void initState() {
    super.initState();
    _chatsSubscription = Chats.onValueChanged.listen((value) {
      _handleChatsValueChanged(value);
    });
  }

  @override
  void dispose() {
    _chatsSubscription.cancel();
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleChatsValueChanged(int value) {
    // Здесь вы можете выполнять действия при изменении переменной value
    print('Chats value changed: $value');
  }

  void _navigateToRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  void _navigateToAllChats(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AllChatsPage()),
    );
  }

  void _falseLoginAccount(BuildContext context) {
    String login = _loginController.text;
    String password = _passwordController.text;

    print('Login: $login');
    print('Password: $password');

    print('Return Login');
    _navigateToAllChats(context);
  }

  void _loginAccount(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Login'),
        toolbarHeight: 200.0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _loginController,
                decoration: const InputDecoration(
                  labelText: 'Login',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _falseLoginAccount(context),
                child: Text('Login'),
              ),
              SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _navigateToRegisterPage(context),
                    child: Text('Go to Registration'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
