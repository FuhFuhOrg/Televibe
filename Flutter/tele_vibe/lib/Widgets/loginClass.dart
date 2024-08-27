import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/ViewModel/loginVM.dart';
import 'package:tele_vibe/Widgets/allChatsClass.dart';
import 'package:tele_vibe/Widgets/registrationClass.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginClassState createState() => _LoginClassState();
}

class _LoginClassState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginVM _loginVM = LoginVM();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text('Login'),
            ),
            toolbarHeight: MediaQuery.of(context).size.height * 0.25,
            automaticallyImplyLeading: false,
          ),
        body: Form(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
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
                    obscureText: true,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.523), // Это уродство, но мне в падлу менять, мб найду что-то на подобии constraint layout
                  ElevatedButton(
                    onPressed: () => _loginVM.loginAccount(context, _loginController, _passwordController),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(120, 160, 131, 1),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => _loginVM.navigateToRegisterPage(context),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(120, 160, 131, 1),
                        ),
                        child: const Text(
                          'Go to Registration',
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
      ),
    );
  }
}
