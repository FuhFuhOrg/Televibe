import 'dart:ffi';

import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/cryptController.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/api.dart'; // Импорт необходимых классов и интерфейсов
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/key_generators/api.dart' as keygen;
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/Data/user.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart';
import 'package:tele_vibe/GettedData/cryptController.dart';
import 'package:tele_vibe/GettedData/localDataSaveController.dart';
import 'package:tele_vibe/GettedData/netServerController.dart';

// Вот здесь поменяй, где ты держишь этот чертов юзер айди, потому что я в душе не чаю, какой из них именно этого пользователя
class changeVeluesInProfileScreenVM {
  int? getUserId() { // Для чужого профиля
    return 666;
    //Chats.getValue().chats.first.yourUserId;
  }

  void changePhoneNumber(String newPhoneNumber)
  {
    // Изменение номера телефона в бд
  }

  void changeUsername(String newUsername)
  {
    // Изменение имени пользователя
  }

  void changeNewAbout(String newAbout)
  {
    // Изменение информации о себе
  }
}