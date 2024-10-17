import 'dart:convert';
import 'dart:math';

import 'package:encrypt/encrypt.dart' as encrypt;

class CryptController {
  static (encrypt.IV, encrypt.Encrypter) GenCrypter(String aesEncryptionKey) {
    // Дополняем или обрезаем ключ до 32 символов (256 бит)
    final String paddedKey = aesEncryptionKey.padRight(32, '0').substring(0, 32);
    
    // Создаем ключ из строки
    final key = encrypt.Key.fromUtf8(paddedKey);

    // Создаем IV из первых 16 символов ключа
    String ivString = aesEncryptionKey.padRight(16, '0').substring(0, 16);
    final iv = encrypt.IV.fromUtf8(ivString);

    // Возвращаем IV и Encrypter
    return (
      iv,
      encrypt.Encrypter(
        encrypt.AES(
          key, 
          mode: encrypt.AESMode.ctr, 
          padding: null
        )
      )
    );
  }
    
  static String generateRandomString(int len) {
    var r = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

  static (String, String) getRandomKeys(){
    return (generateRandomString(128), generateRandomString(128));
  }

  // Функция для шифрования текста
  static String encryptAES(String text, String key) {
    // Получаем IV и Encrypter с помощью GenCrypter
    final (iv, encrypter) = GenCrypter(key);

    // Шифруем текст
    final encrypted = encrypter.encrypt(text, iv: iv);

    // Возвращаем результат в виде строки Base64
    return encrypted.base64;
  }

  // Функция для расшифровки текста
  static String decryptAES(String encrypted, String key) {
    // Декодируем зашифрованный текст из Base64
    final encryptedBytes = base64.decode(encrypted);

    // Создаем IV и Encrypter с помощью GenCrypter (используем тот же ключ и первые 16 символов для IV)
    final (iv, encrypter) = GenCrypter(key);

    // Расшифровываем данные, используя Encrypter и IV
    final decrypted = encrypter.decrypt(
      encrypt.Encrypted(encryptedBytes),
      iv: iv,
    );

    return decrypted;
  }
}