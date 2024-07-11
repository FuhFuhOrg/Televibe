import 'package:flutter/material.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/Widgets/ViewModel/loginClass.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegisterClassState createState() => _RegisterClassState();
}

 
class _RegisterClassState extends State<RegistrationPage> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();


  void _navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
  
  void _registrationNewAccount(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _mailController,
                decoration: InputDecoration(
                  labelText: 'Mail',
                  border: OutlineInputBorder(),
                  helperText: "Необязательно",
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _loginController,
                decoration: InputDecoration(
                  labelText: 'Login',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _rePasswordController,
                decoration: InputDecoration(
                  labelText: 'Re Password',
                  helperText: "Повторите пароль",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _registrationNewAccount(context),
                child: Text('Register'),
              ),
              SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _navigateToLoginPage(context),
                    child: Text('Go to Login'),
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
