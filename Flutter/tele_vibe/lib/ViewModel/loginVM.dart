import 'package:flutter/material.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/Data/user.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart';
import 'package:tele_vibe/GettedData/localDataSaveController.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:tele_vibe/Widgets/allChatsClass.dart';
import 'package:tele_vibe/Widgets/registrationClass.dart';

class LoginVM {

  void navigateToRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationPage()),
    );
  }

  // Проверка сохраненных учетных данных и автоматический вход
  Future<bool> tryAutoLogin(BuildContext context) async {
    var (login, password) = await LocalDataSave.loadCredentials();
    if (login != null && password != null) {
      print('Попытка автоматического входа: $login');
      List<String> goin = await NetServerController().login(login, password);
      
      if (goin.isNotEmpty && goin[0] == "true") {
        print('Автоматический вход успешен');
        Anon.anonId = int.tryParse(goin[1]);
        Anon.anonPassword = password;
        _startChatsAddiction();
        _navigateToAllChats(context);
        return true;
      } else {
        print('Автоматический вход не удался');
        await LocalDataSave.clearCredentials();
      }
    }
    return false;
  }

  void fakeLoginAccount(BuildContext context, 
  TextEditingController loginController, TextEditingController passwordController) {
    String login = loginController.text;
    String password = passwordController.text;

    print('Login: $login');
    print('Password: $password');

    print('Return Login');
    
    _startChatsAddiction();
    _navigateToAllChats(context);
  }

  void loginAccount(BuildContext context, 
  TextEditingController loginController, TextEditingController passwordController) {
    String login = loginController.text;
    String password = passwordController.text;

    print('Login: $login');
    print('Password: $password');

    NetServerController().login(login, password).then((goin) {
      if (goin != " " && goin != "") {
        print('Return Login ${goin}');
        if(goin[0] == "true") {
          // Сохраняем учетные данные при успешном входе
          LocalDataSave.saveCredentials(login, password);
          
          Anon.anonId = int.tryParse(goin[1]);
          Anon.anonPassword = password;
          _startChatsAddiction();
          _navigateToAllChats(context);
        }
        else{
          MessageHandler.showAlertDialog(context, '${goin.join(" ")}');
        }
      }
    });
  }

  void _startChatsAddiction(){
    // Код вызывающий подгрузку Json и WS чатов
    LocalDataSave.loadChatsData().then((goin) {
      if (goin != null){
        Chats.setValue(goin);
      }
    });
  }

  void _navigateToAllChats(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllChatsPage()),
    );
  }
}