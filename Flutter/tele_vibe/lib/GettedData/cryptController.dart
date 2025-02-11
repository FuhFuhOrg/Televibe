import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/api.dart'; // Импорт необходимых классов и интерфейсов
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/key_generators/api.dart' as keygen;
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';

class CryptController {
  // Функция для создания AES шифратора
  static (encrypt.IV, encrypt.Encrypter) GenCrypter(String aesEncryptionKey) {
    final String paddedKey = aesEncryptionKey.padRight(32, '0').substring(0, 32);
    final key = encrypt.Key.fromUtf8(paddedKey);
    String ivString = aesEncryptionKey.padRight(16, '0').substring(0, 16);
    final iv = encrypt.IV.fromUtf8(ivString);

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

  // Функция для шифрования текста (AES)
  static String encryptAES(String text, String key) {
    final (iv, encrypter) = GenCrypter(key);
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  // Функция для расшифровки текста (AES)
  static String decryptAES(String encrypted, String key) {
    final encryptedBytes = base64.decode(encrypted);
    final (iv, encrypter) = GenCrypter(key);
    final decrypted = encrypter.decrypt(
      encrypt.Encrypted(encryptedBytes),
      iv: iv,
    );
    return decrypted;
  }

  // Функция для генерации пары RSA-ключей
  static (RSAPublicKey, RSAPrivateKey) generateRSAKeyPair() {
    final keyParams = keygen.RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 12);
    final secureRandom = _getSecureRandom();
    final generator = RSAKeyGenerator()
      ..init(ParametersWithRandom(keyParams, secureRandom));
    final pair = generator.generateKeyPair();
    final publicKey = pair.publicKey as RSAPublicKey;
    final privateKey = pair.privateKey as RSAPrivateKey;

    return (publicKey, privateKey);
  }

  // Генерация криптостойкого случайного генератора
  static FortunaRandom _getSecureRandom() {
    final secureRandom = FortunaRandom();
    final seedSource = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seedSource)));
    return secureRandom;
  }

  // Шифрование текста с использованием RSA (подписывание приватным ключом)
  static String encryptRSA(String text, RSAPublicKey publicKey) {
    final encrypter = encrypt.Encrypter(encrypt.RSA(publicKey: publicKey));
    final encrypted = encrypter.encrypt(text);
    return encrypted.base64;
  }

  // Расшифровка текста с использованием RSA (любой с публичным ключом может расшифровать)
  static String decryptRSA(String encrypted, RSAPrivateKey privateKey) {
    final encryptedBytes = base64.decode(encrypted);
    final encrypter = encrypt.Encrypter(encrypt.RSA(privateKey: privateKey));
    final decrypted = encrypter.decrypt(encrypt.Encrypted(encryptedBytes));
    return decrypted;
  }
  
  static String xorEncryptWithExtendedKey(String text, String key) {
    // Расширение ключа до длины текста
    String extendedKey = _extendKey(key, text.length);
    
    // Шифрование с использованием XOR
    List<int> encryptedChars = List<int>.generate(text.length, (i) {
      return text.codeUnitAt(i) ^ extendedKey.codeUnitAt(i);
    });

    return String.fromCharCodes(encryptedChars);
  }

  static String _extendKey(String key, int length) {
    // Если ключ короче нужной длины, повторить его
    while (key.length < length) {
      key += key;
    }
    // Обрезать ключ до нужной длины
    return key.substring(0, length);
  }

  // Кодирование публичного ключа в PEM-формат
  static String encodePublicKey(RSAPublicKey publicKey) {
    BigInt? m = publicKey.modulus;
    BigInt? e = publicKey.exponent;
    if(e != null && m != null){
      return ("${m.toString()} ${e.toString()}");
    }
    return "";
  }

  // Кодирование приватного ключа в PEM-формат
  static String encodePrivateKey(RSAPrivateKey privateKey) {
    BigInt? m = privateKey.modulus;
    BigInt? privExp = privateKey.privateExponent;
    BigInt? p = privateKey.p;
    BigInt? q = privateKey.q;
    BigInt? pubExp = privateKey.publicExponent;
    if(p != null && q != null && m != null && privExp != null && pubExp != null){
      List<BigInt> numbers = [
        m,
        privExp,
        p,
        q,
        pubExp
      ];

      String result = "";
      //String result = numbers.map((e) => e.toString()).join('\n');  
      for (BigInt kek in numbers){
        result += (kek.toString() + "\n");
      }

      return result;
    }
    return "";
  }

  // Декодирование публичного ключа из PEM
  static RSAPublicKey decodePublicKey(String pem) {
    List<String> strBigInt = pem.split(" ");
    List<BigInt> BigInts = [];
    for(String str in strBigInt){
      BigInts.add(BigInt.parse(str));
    }
    BigInt? m = BigInts[0];
    BigInt? e = BigInts[1];
    RSAPublicKey RSAPK = RSAPublicKey(m, e);
    return RSAPK;
  }

  // Декодирование приватного ключа из PEM
  static RSAPrivateKey decodePrivateKey(String pem) {
    List<String> strBigInt = pem.split("_");
    List<BigInt> BigInts = [];
    for(String str in strBigInt){
      BigInts.add(BigInt.parse(str));
    }
    BigInt? m = BigInts[0];
    BigInt? privExp = BigInts[1];
    BigInt? p = BigInts[2];
    BigInt? q = BigInts[3];
    BigInt? pubExp = BigInts[4];
    RSAPrivateKey RSAPK = RSAPrivateKey(m, privExp, p, q, pubExp);
    return RSAPK;
  }

  static String encryptPublicKey(String publicKey, String chatId, String chatPassword, int login, String password) {
    String combinedKey = chatId + chatPassword + login.toString() + password;
    return xorEncryptWithExtendedKey(publicKey, combinedKey);
  }

  static String encryptPrivateKey(String privateKey, String chatId, String chatPassword) {
    String combinedKey = chatId + chatPassword;
    return xorEncryptWithExtendedKey(privateKey, combinedKey);
  }

  static String decryptPublicKey(String encryptedPublicKey, String chatId, String chatPassword, int login, String password) {
    String combinedKey = chatId + chatPassword + login.toString() + password;
    return xorEncryptWithExtendedKey(encryptedPublicKey, combinedKey);
  }

  static String decryptPrivateKey(String encryptedPrivateKey, String chatId, String chatPassword) {
    String combinedKey = chatId + chatPassword;
    return xorEncryptWithExtendedKey(encryptedPrivateKey, combinedKey);
  }

  static String encryptAnonId(String anonId, String chatId, String chatPassword, String password) {
    String combinedKey = chatId + chatPassword + password;
    return xorEncryptWithExtendedKey(anonId, combinedKey);
  }

  static String decryptAnonId(String encryptedAnonId, String chatId, String chatPassword, String password) {
    String combinedKey = chatId + chatPassword + password;
    return xorEncryptWithExtendedKey(encryptedAnonId, combinedKey);
  }
}
