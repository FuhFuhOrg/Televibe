package com.example.teletypesha.crypt;

import android.util.Pair;

import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.User;

import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.MessageDigest;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.X509EncodedKeySpec;
import java.util.Arrays;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

public final class Crypt {

    public static Pair<PrivateKey, PublicKey> PublicPrivateKeyGeneration() throws Exception {
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
        keyPairGenerator.initialize(2048);
        KeyPair keyPair = keyPairGenerator.generateKeyPair();
        PrivateKey privateKey = keyPair.getPrivate();
        PublicKey publicKey = keyPair.getPublic();
        return new Pair<>(privateKey, publicKey);
    }

    public static byte[] Encryption(String msg, PrivateKey privateKey) throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        SecretKey secretKey = keyGen.generateKey();

        Cipher aesCipher = Cipher.getInstance("AES");
        aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
        byte[] encryptedMsg = aesCipher.doFinal(msg.getBytes());

        Cipher rsaCipher = Cipher.getInstance("RSA");
        rsaCipher.init(Cipher.WRAP_MODE, privateKey);
        byte[] encryptedKey = rsaCipher.wrap(secretKey);

        byte[] combined = new byte[encryptedKey.length + encryptedMsg.length];
        System.arraycopy(encryptedKey, 0, combined, 0, encryptedKey.length);
        System.arraycopy(encryptedMsg, 0, combined, encryptedKey.length, encryptedMsg.length);

        return combined;
    }

    public static String Decrypt(byte[] combined, PublicKey publicKey) throws Exception {
        byte[] encryptedKey = new byte[256];
        byte[] encryptedMsg = new byte[combined.length - 256];
        System.arraycopy(combined, 0, encryptedKey, 0, 256);
        System.arraycopy(combined, 256, encryptedMsg, 0, encryptedMsg.length);

        Cipher rsaCipher = Cipher.getInstance("RSA");
        rsaCipher.init(Cipher.UNWRAP_MODE, publicKey);
        SecretKey secretKey = (SecretKey) rsaCipher.unwrap(encryptedKey, "AES", Cipher.SECRET_KEY);

        Cipher aesCipher = Cipher.getInstance("AES");
        aesCipher.init(Cipher.DECRYPT_MODE, secretKey);
        byte[] decryptedMsg = aesCipher.doFinal(encryptedMsg);

        return new String(decryptedMsg);
    }

    public static String CriptPublicKey(String chatId, String chatPass, PublicKey publicKey) throws Exception {
        // Объединяем два ключевых слова
        String key = chatId + chatPass;

        // Генерация ключа AES из строки
        MessageDigest sha = MessageDigest.getInstance("SHA-256");
        byte[] keyBytes = key.getBytes(StandardCharsets.UTF_8);
        keyBytes = sha.digest(keyBytes);
        keyBytes = Arrays.copyOf(keyBytes, 16); // Используем только первые 128 бит

        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, "AES");

        // Инициализация шифра
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, secretKey);

        // Шифрование и кодирование в Base64
        byte[] encrypted = cipher.doFinal(publicKey.getEncoded());
        String encryptedString = Base64.getEncoder().encodeToString(encrypted);

        return encryptedString;
    }


    public static PublicKey DecryptPublicKey(String chatId, String chatPass, String encryptedString) throws Exception {
        // Объединяем два ключевых слова
        String key = chatId + chatPass;

        // Генерация ключа AES из строки
        MessageDigest sha = MessageDigest.getInstance("SHA-256");
        byte[] keyBytes = key.getBytes(StandardCharsets.UTF_8);
        keyBytes = sha.digest(keyBytes);
        keyBytes = Arrays.copyOf(keyBytes, 16); // Используем только первые 128 бит

        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, "AES");

        // Инициализация шифра
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, secretKey);

        // Декодирование строки Base64 и расшифровка
        byte[] encryptedBytes = Base64.getDecoder().decode(encryptedString);
        byte[] decryptedBytes = cipher.doFinal(encryptedBytes);

        // Восстановление публичного ключа
        PublicKey decrypted = KeyFactory.getInstance("RSA").generatePublic(new X509EncodedKeySpec(decryptedBytes));

        return decrypted;
    }

}