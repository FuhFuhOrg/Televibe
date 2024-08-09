

import 'package:flutter/material.dart';
import 'package:tele_vibe/ViewModel/loginVM.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginClassState createState() => _LoginClassState();
}

class _LoginClassState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginVM _loginVM;

  @override
  void initState() {
    super.initState();
    _loginVM = LoginVM();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
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
      body: Form(
        child: Scrollbar(
          child: SingleChildScrollView(
=======
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Login'),
          toolbarHeight: 200.0,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
>>>>>>> Stashed changes
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
<<<<<<< Updated upstream
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
                  onPressed: () => _falseLoginAccount(context),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(120, 160, 131, 1),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 32),
=======
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
                  onPressed: () => _loginVM.fakeLoginAccount(context, _loginController, _passwordController),
                  child: Text('Login'),
                ),
                SizedBox(height: 64),
>>>>>>> Stashed changes
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
<<<<<<< Updated upstream
                      onPressed: () => _navigateToRegisterPage(context),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(120, 160, 131, 1),
                      ),
                      child: const Text(
                        'Go to Registration',
                        style: TextStyle(color: Colors.black),
                      ),
=======
                      onPressed: () => _loginVM.navigateToRegisterPage(context),
                      child: Text('Go to Registration'),
>>>>>>> Stashed changes
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
