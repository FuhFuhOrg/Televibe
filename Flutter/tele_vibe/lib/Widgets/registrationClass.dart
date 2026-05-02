import 'package:flutter/material.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/ViewModel/registrationVM.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegisterClassState();
}

class _RegisterClassState extends State<RegistrationPage> {
  bool _obscureTextPassword = true;
  bool _obscureTextRePassword = true;
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final RegistrationVM _registrationVM = RegistrationVM();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 14),
              const CircleAvatar(
                radius: 38,
                backgroundColor: Color(0xFF2AABEE),
                child: Icon(
                  Icons.person_add_alt_1_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                l10n.createAccountHeading,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.registrationSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF7F91A4),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF17212B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF243447)),
                ),
                child: Text(
                  l10n.registrationIntro,
                  style: const TextStyle(
                    color: Color(0xFF9FB0C0),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              TextField(
                cursorColor: const Color(0xFF2AABEE),
                controller: _loginController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                    l10n.loginLabel, Icons.alternate_email_rounded),
              ),
              const SizedBox(height: 14),
              TextField(
                cursorColor: const Color(0xFF2AABEE),
                controller: _passwordController,
                obscureText: _obscureTextPassword,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  l10n.passwordLabel,
                  Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTextPassword
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: const Color(0xFF7F91A4),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureTextPassword = !_obscureTextPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                cursorColor: const Color(0xFF2AABEE),
                controller: _rePasswordController,
                obscureText: _obscureTextRePassword,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  l10n.repeatPasswordLabel,
                  Icons.verified_user_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTextRePassword
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: const Color(0xFF7F91A4),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureTextRePassword = !_obscureTextRePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 26),
              FilledButton(
                onPressed: () => _registrationVM.registerNewAccount(
                  context,
                  _loginController,
                  _passwordController,
                  _rePasswordController,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2AABEE),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.createAccount),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.alreadyHaveAccount,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF7F91A4)),
              ),
              TextButton(
                onPressed: () => _registrationVM.navigateToLoginPage(context),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF7F91A4),
                ),
                child: Text(l10n.backToSignIn),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF7F91A4)),
      prefixIcon: Icon(icon, color: const Color(0xFF7F91A4)),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFF17212B),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF243447)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2AABEE)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
