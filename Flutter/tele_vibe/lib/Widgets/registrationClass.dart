import 'package:flutter/material.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/Widgets/loginClass.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegisterClassState createState() => _RegisterClassState();
}


class _RegisterClassState extends State<RegistrationPage> {
  bool _obscureTextPassword = true; // Сокрытие пароля
  bool _obscureTextRePassword = true;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text('Login'),
          ),
          toolbarHeight: MediaQuery.of(context).size.height * 0.25,
          automaticallyImplyLeading: false,
        ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,// ограничение в 90% от краев экрана
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 8),
              TextField(
                cursorColor: Colors.black,
                controller: _mailController,
                decoration: const InputDecoration(
                  labelText: 'Mail (необязательно)',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  contentPadding: EdgeInsets.only(left: 10.0),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                cursorColor: Colors.black,
                controller: _loginController,
                decoration: const InputDecoration(
                  labelText: 'Login',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), 
                  ),
                  contentPadding: EdgeInsets.only(left: 10.0),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                cursorColor: Colors.black,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), 
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red), 
                  ),
                  suffix: IconButton(
                    icon: Icon(
                      _obscureTextPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureTextPassword = !_obscureTextPassword;
                      });
                    }
                  ),
                  contentPadding: const EdgeInsets.only(left: 10.0),
                ),
                obscureText: _obscureTextPassword,
              ),
              const SizedBox(height: 8),
              TextField(
                cursorColor: Colors.black,
                controller: _rePasswordController,
                decoration: InputDecoration(
                  labelText: 'Re Password',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black), 
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  suffix: IconButton(
                    icon: Icon(
                      _obscureTextRePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureTextRePassword = !_obscureTextRePassword;
                      });
                    }
                  ),
                  contentPadding: const EdgeInsets.only(left: 10.0),
                ),
                obscureText: _obscureTextRePassword,
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.40),
              ElevatedButton(
                onPressed: () => _registrationNewAccount(context),
                style: TextButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(120, 160, 131, 1),
                    ),
                child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.black),
                      
                    )
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
    );
  }
}
