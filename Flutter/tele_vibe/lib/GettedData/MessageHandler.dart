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
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Окно нельзя закрыть нажатием вне диалога
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Сообщение'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Закрытие диалога
              },
            ),
          ],
        );
      },
    );
  }
}
