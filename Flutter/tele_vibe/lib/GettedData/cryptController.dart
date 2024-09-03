import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;

class CryptController {
  static late encrypt.IV iv;
  late String aesEncryptionKey;
  static late encrypt.Encrypter encrypter;
  
  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  (String, String) GetKeys(){
    return (generateRandomString(128), generateRandomString(128));
  }

  CryptController._() {
    aesEncryptionKey = generateRandomString(128);
    iv = encrypt.IV.fromUtf8(aesEncryptionKey);
    encrypter = encrypt.Encrypter(encrypt.AES(
      encrypt.Key.fromUtf8(aesEncryptionKey), 
      mode: encrypt.AESMode.ctr, padding: null));
  }

  String encryptAES(String text) {
    return encrypter.encrypt(text, iv: iv).base64;
  }

  String decryptAES(String encrypted) {
    final Uint8List encryptedBytesWithSalt = base64.decode(encrypted);
    final Uint8List encryptedBytes = encryptedBytesWithSalt.sublist(
      0,
      encryptedBytesWithSalt.length,
    );
    final String decrypted =
        encrypter.decrypt64(base64.encode(encryptedBytes), iv: iv);
    return decrypted;
  }
}