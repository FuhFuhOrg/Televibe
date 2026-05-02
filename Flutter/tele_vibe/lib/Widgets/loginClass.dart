import 'package:flutter/material.dart';
import 'package:tele_vibe/Localization/context_extensions.dart';
import 'package:tele_vibe/ViewModel/loginVM.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.enableAutoLogin = true});

  final bool enableAutoLogin;

  @override
  State<LoginPage> createState() => _LoginClassState();
}

class _LoginClassState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginVM _loginVM = LoginVM();
  bool _obscureTextPassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.enableAutoLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        setState(() => _isLoading = true);
        await _loginVM.tryAutoLogin(context);
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      body: SafeArea(
        child: Form(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 28),
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: Color(0xFF2AABEE),
                  child: Icon(
                    Icons.chat_bubble_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Televibe',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.signIn,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF7F91A4),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF17212B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF243447)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.wifi_tethering_rounded,
                            color: Color(0xFF2AABEE),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.readyForLiveSync,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.loginIntro,
                        style: const TextStyle(
                          color: Color(0xFF9FB0C0),
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 34),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: const Color(0xFF2AABEE),
                  controller: _loginController,
                  decoration:
                      _inputDecoration(l10n.loginLabel, Icons.person_outline),
                ),
                const SizedBox(height: 14),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: const Color(0xFF2AABEE),
                  controller: _passwordController,
                  decoration:
                      _inputDecoration(l10n.passwordLabel, Icons.lock_outline)
                          .copyWith(
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
                  obscureText: _obscureTextPassword,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isLoading ? null : _runLogin,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2AABEE),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.signIn),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _isLoading
                      ? null
                      : _openPreparedChats,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(l10n.openChats),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2AABEE),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.newToTelevibe,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF7F91A4)),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => _loginVM.navigateToRegisterPage(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF7F91A4),
                    ),
                    child: Text(l10n.createAccount),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF7F91A4)),
      prefixIcon: Icon(icon, color: const Color(0xFF7F91A4)),
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

  Future<void> _runLogin() async {
    setState(() => _isLoading = true);
    await _loginVM.loginAccount(context, _loginController, _passwordController);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _openPreparedChats() async {
    setState(() => _isLoading = true);
    await _loginVM.openPreparedChats(context);
    if (mounted) setState(() => _isLoading = false);
  }
}
