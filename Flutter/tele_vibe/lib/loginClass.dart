import 'package:flutter/material.dart';
import 'package:tele_vibe/chats.dart';
import 'package:tele_vibe/registerClass.dart';

class LoginClass extends StatelessWidget {
  const LoginClass({super.key});

  void _incrementCounter(BuildContext context) {
    Counter.value++;
  }

  void _navigateToRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterClass()),
    );
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
                decoration: InputDecoration(
                  labelText: 'Login',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle login button press
                },
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
