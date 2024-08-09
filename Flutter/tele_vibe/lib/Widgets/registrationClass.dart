import 'package:flutter/material.dart';
import 'package:tele_vibe/ViewModel/registrationVM.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

<<<<<<< Updated upstream

class _RegisterClassState extends State<RegistrationPage> {
  bool _obscureTextPassword = true; // Сокрытие пароля
  bool _obscureTextRePassword = true;
=======
class _RegistrationPageState extends State<RegistrationPage> {
>>>>>>> Stashed changes
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  late RegistrationVM _registrationVM;

  @override
  void initState() {
    super.initState();
    _registrationVM = RegistrationVM();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Registration'),
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
                controller: _mailController,
                decoration: const InputDecoration(
                  labelText: 'Mail (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
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
              TextField(
                controller: _rePasswordController,
                decoration: InputDecoration(
                  labelText: 'Re-Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _registrationVM.registerNewAccount(context, _mailController, _loginController, _passwordController, _rePasswordController),
                child: Text('Register'),
              ),
              SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _registrationVM.navigateToLoginPage(context),
                    child: Text('Go to Login'),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _navigateToLoginPage(context),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(120, 160, 131, 1),
                      ),
                      child: const Text(
                        'Go to Login',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
