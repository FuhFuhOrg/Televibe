import 'package:flutter/material.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/ViewModel/registrationVM.dart';
import 'package:tele_vibe/Widgets/loginClass.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text('Registration'),
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
                SizedBox(height: MediaQuery.of(context).size.width * 0.25),
                ElevatedButton(
                  onPressed: () => _registrationVM.registerNewAccount(context, _mailController, 
                  _loginController, _passwordController, _rePasswordController),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(120, 160, 131, 1),
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
                      onPressed: () => _registrationVM.navigateToLoginPage(context),
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
