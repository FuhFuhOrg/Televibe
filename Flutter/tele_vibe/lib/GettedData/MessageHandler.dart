import 'package:flutter/material.dart';

class MessageHandler {
  // Метод для вывода Snackbar
  static void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Метод для показа диалогового окна
  static Future<void> showAlertDialog(BuildContext context, String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF222222),
      ),
    );
  }
}
