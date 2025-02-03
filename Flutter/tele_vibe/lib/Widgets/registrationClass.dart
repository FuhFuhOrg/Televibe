import 'package:flutter/material.dart';
import 'package:tele_vibe/ViewModel/registrationVM.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegisterClassState createState() => _RegisterClassState();
}


class _RegisterClassState extends State<RegistrationPage> {
  bool _obscureTextPassword = true;
  bool _obscureTextRePassword = true;
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final RegistrationVM _registrationVM = RegistrationVM();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        title: const Center(
          child: Text('Registration', style: TextStyle(color: Colors.white)),
          ),
          toolbarHeight: MediaQuery.of(context).size.height * 0.25,
          automaticallyImplyLeading: false,
        ),
      body: Form(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 8),
                /*
                TextField(
                  cursorColor: Colors.white,
                  controller: _mailController,
                  decoration: const InputDecoration(
                    labelText: 'Mail (необязательно)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    contentPadding: EdgeInsets.only(left: 10.0),
                  ),
                ),
                */
                const SizedBox(height: 8),
                TextField(
                  cursorColor: Colors.white,
                  controller: _loginController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Login',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red), 
                    ),
                    contentPadding: EdgeInsets.only(left: 10.0),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  cursorColor: Colors.white,
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), 
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
                  cursorColor: Colors.white,
                  controller: _rePasswordController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Re Password',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), 
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    suffix: IconButton(
                      icon: Icon(
                        _obscureTextRePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
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
                SizedBox(height: MediaQuery.of(context).size.width * 0.375),
                ElevatedButton(
                  onPressed: () => _registrationVM.registerNewAccount(context, /*_mailController,*/ 
                  _loginController, _passwordController, _rePasswordController),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF222222),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _registrationVM.navigateToLoginPage(context),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                      ),
                      child: const Text(
                        'Go to Login',
                        style: TextStyle(color: Colors.white),
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
