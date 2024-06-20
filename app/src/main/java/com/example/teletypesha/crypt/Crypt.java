package com.example.teletypesha.crypt;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.Image;
import android.os.Build;
import android.util.Pair;
import android.widget.ImageView;

import androidx.core.app.NotificationCompat;

import com.example.teletypesha.R;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.User;
import com.example.teletypesha.jsons.JsonDataSaver;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import org.json.JSONObject;

import java.io.ByteArrayInputStream;
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
    private static final String CHANNEL_ID = "encryption_channel";
    private static final int NOTIFICATION_ID = 1;

    // Генерация пары открытого и закрытого ключей RSA
    public static Pair<PrivateKey, PublicKey> PublicPrivateKeyGeneration() throws Exception {
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
        keyPairGenerator.initialize(2048);
        KeyPair keyPair = keyPairGenerator.generateKeyPair();
        PrivateKey privateKey = keyPair.getPrivate();
        PublicKey publicKey = keyPair.getPublic();
        return new Pair<>(privateKey, publicKey);
    }

    // Шифрование строки с использованием AES и закрытого ключа RSA
    public static byte[] Encryption(String msg, PrivateKey privateKey) throws Exception {
        // Генерация секретного ключа AES
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        SecretKey secretKey = keyGen.generateKey();

        // Шифрование сообщения с использованием AES
        Cipher aesCipher = Cipher.getInstance("AES");
        aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);
        byte[] encryptedMsg = aesCipher.doFinal(msg.getBytes());

        // Шифрование секретного ключа AES с использованием RSA
        Cipher rsaCipher = Cipher.getInstance("RSA");
        rsaCipher.init(Cipher.WRAP_MODE, privateKey);
        byte[] encryptedKey = rsaCipher.wrap(secretKey);

        // Комбинирование зашифрованного ключа и зашифрованного сообщения
        byte[] combined = new byte[encryptedKey.length + encryptedMsg.length];
        System.arraycopy(encryptedKey, 0, combined, 0, encryptedKey.length);
        System.arraycopy(encryptedMsg, 0, combined, encryptedKey.length, encryptedMsg.length);

        return combined;
    }

    // Шифрование изображения с использованием AES и закрытого ключа RSA, с уведомлениями о прогрессе
    public static byte[] EncryptionImage(Context context, byte[] msg, PrivateKey privateKey) throws Exception {
        // Генерация секретного ключа AES
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        SecretKey secretKey = keyGen.generateKey();

        // Инициализация шифра AES для шифрования
        Cipher aesCipher = Cipher.getInstance("AES");
        aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);

        // Настройка уведомлений
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, "Encryption Progress", NotificationManager.IMPORTANCE_LOW);
            notificationManager.createNotificationChannel(channel);
        }

        // Переменные для отслеживания прогресса
        int totalBytesProcessed = 0;
        int chunkSize = 1024 * 1024; // 1024 КБ
        byte[] buffer = new byte[chunkSize];
        int bytesRead = 0;

        // Поток для хранения зашифрованных данных изображения
        ByteArrayOutputStream encryptedStream = new ByteArrayOutputStream();

        // Шифрование изображения по частям
        for (int offset = 0; offset < msg.length; offset += chunkSize) {
            bytesRead = Math.min(chunkSize, msg.length - offset);
            System.arraycopy(msg, offset, buffer, 0, bytesRead);
            byte[] encryptedChunk = aesCipher.doFinal(buffer, 0, bytesRead);
            encryptedStream.write(encryptedChunk);
            totalBytesProcessed += bytesRead;

            // Обновление уведомления о прогрессе
            if (totalBytesProcessed % chunkSize == 0) {
                String notificationText = totalBytesProcessed + " байт зашифровано";
                Notification notification = new NotificationCompat.Builder(context, CHANNEL_ID)
                        .setContentTitle("Шифрование в процессе")
                        .setContentText(notificationText)
                        .setSmallIcon(R.drawable.ic_encryption)
                        .setProgress(msg.length, totalBytesProcessed, false)
                        .build();
                notificationManager.notify(NOTIFICATION_ID, notification);
            }
        }

        byte[] encryptedMsg = encryptedStream.toByteArray();

        // Шифрование секретного ключа AES с использованием RSA
        Cipher rsaCipher = Cipher.getInstance("RSA");
        rsaCipher.init(Cipher.WRAP_MODE, privateKey);
        byte[] encryptedKey = rsaCipher.wrap(secretKey);

        // Комбинирование зашифрованного ключа и зашифрованного изображения
        byte[] combined = new byte[encryptedKey.length + encryptedMsg.length];
        System.arraycopy(encryptedKey, 0, combined, 0, encryptedKey.length);
        System.arraycopy(encryptedMsg, 0, combined, encryptedKey.length, encryptedMsg.length);

        // Финальное уведомление
        String finalNotificationText = "Шифрование завершено: " + combined.length + " байт";
        Notification finalNotification = new NotificationCompat.Builder(context, CHANNEL_ID)
                .setContentTitle("Шифрование завершено")
                .setContentText(finalNotificationText)
                .setSmallIcon(R.drawable.ic_encryption)
                .setProgress(0, 0, false)
                .build();
        notificationManager.notify(NOTIFICATION_ID, finalNotification);

        return combined;
    }

    // Расшифровка зашифрованного байтового массива в строку с использованием RSA и AES
    public static String Decrypt(byte[] combined, PublicKey publicKey) throws Exception {
        // Извлечение зашифрованного ключа AES и зашифрованного сообщения
        byte[] encryptedKey = new byte[256];
        byte[] encryptedMsg = new byte[combined.length - 256];
        System.arraycopy(combined, 0, encryptedKey, 0, 256);
        System.arraycopy(combined, 256, encryptedMsg, 0, encryptedMsg.length);

        // Расшифровка ключа AES с использованием RSA
        Cipher rsaCipher = Cipher.getInstance("RSA");
        rsaCipher.init(Cipher.UNWRAP_MODE, publicKey);
        SecretKey secretKey = (SecretKey) rsaCipher.unwrap(encryptedKey, "AES", Cipher.SECRET_KEY);

        // Расшифровка сообщения с использованием AES
        Cipher aesCipher = Cipher.getInstance("AES");
        aesCipher.init(Cipher.DECRYPT_MODE, secretKey);
        byte[] decryptedMsg = aesCipher.doFinal(encryptedMsg);

        return new String(decryptedMsg);
    }

    // Расшифровка зашифрованного байтового массива в изображение Bitmap с использованием RSA и AES
    public static Bitmap DecryptImage(byte[] combined, PublicKey publicKey) throws Exception {
        // Извлечение зашифрованного ключа AES и зашифрованного изображения
        byte[] encryptedKey = new byte[256];
        byte[] encryptedMsg = new byte[combined.length - 256];
        System.arraycopy(combined, 0, encryptedKey, 0, 256);
        System.arraycopy(combined, 256, encryptedMsg, 0, encryptedMsg.length);

        // Расшифровка ключа AES с использованием RSA
        Cipher rsaCipher = Cipher.getInstance("RSA");
        rsaCipher.init(Cipher.UNWRAP_MODE, publicKey);
        SecretKey secretKey = (SecretKey) rsaCipher.unwrap(encryptedKey, "AES", Cipher.SECRET_KEY);

        // Расшифровка изображения с использованием AES
        Cipher aesCipher = Cipher.getInstance("AES");
        aesCipher.init(Cipher.DECRYPT_MODE, secretKey);
        byte[] decryptedMsg = aesCipher.doFinal(encryptedMsg);

        // Преобразование байтового массива в изображение Bitmap
        Bitmap bitmap = BitmapFactory.decodeByteArray(decryptedMsg, 0, decryptedMsg.length);

        return bitmap;
    }

    // Шифрование публичного ключа с использованием комбинации chatId и chatPass, возврат строки Base64
    public static String CriptPublicKey(String chatId, String chatPass, PublicKey publicKey) throws Exception {
        // Объединение chatId и chatPass для формирования ключа
        String key = chatId + chatPass;

        // Генерация ключа AES из объединенной строки
        MessageDigest sha = MessageDigest.getInstance("SHA-256");
        byte[] keyBytes = key.getBytes(StandardCharsets.UTF_8);
        keyBytes = sha.digest(keyBytes);
        keyBytes = Arrays.copyOf(keyBytes, 16); // Используем только первые 128 бит

        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, "AES");

        // Инициализация шифра AES для шифрования
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, secretKey);

        // Шифрование публичного ключа и кодирование в Base64
        byte[] encrypted = cipher.doFinal(publicKey.getEncoded());
        String encryptedString = Base64.getEncoder().encodeToString(encrypted);

        return encryptedString;
    }

    // Расшифровка строки Base64 в публичный ключ с использованием chatId и chatPass
    public static PublicKey DecryptPublicKey(String chatId, String chatPass, String encryptedString) throws Exception {
        // Объединение chatId и chatPass для формирования ключа
        String key = chatId + chatPass;

        // Генерация ключа AES из объединенной строки
        MessageDigest sha = MessageDigest.getInstance("SHA-256");
        byte[] keyBytes = key.getBytes(StandardCharsets.UTF_8);
        keyBytes = sha.digest(keyBytes);
        keyBytes = Arrays.copyOf(keyBytes, 16); // Используем только первые 128 бит

        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, "AES");

        // Инициализация шифра AES для расшифровки
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, secretKey);

        // Декодирование строки Base64 и расшифровка
        byte[] encryptedBytes = Base64.getDecoder().decode(encryptedString);
        byte[] decryptedBytes = cipher.doFinal(encryptedBytes);

        // Восстановление публичного ключа
        PublicKey decrypted = KeyFactory.getInstance("RSA").generatePublic(new X509EncodedKeySpec(decryptedBytes));

        return decrypted;
    }

    // Шифрование информации о пользователе и, при необходимости, данных чатов с использованием логина и пароля
    public static String CriptUser(String login, String password, Context context, Boolean returnChats) throws Exception {
        MessageDigest sha = MessageDigest.getInstance("SHA-256");
        byte[] loginHashBytes = sha.digest(login.getBytes(StandardCharsets.UTF_8));
        String loginHash = bytesToHex(loginHashBytes);

        byte[] passwordHashBytes = sha.digest(password.getBytes(StandardCharsets.UTF_8));
        String passwordHash = bytesToHex(passwordHashBytes);

        // Генерация ключа из логина и пароля
        String key = login + password;
        byte[] keyBytes = key.getBytes(StandardCharsets.UTF_8);
        keyBytes = sha.digest(keyBytes);
        keyBytes = Arrays.copyOf(keyBytes, 16);

        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, "AES");

        // Инициализация шифра AES для шифрования
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, secretKey);

        String result;
        if (returnChats) {
            // Загрузка данных чатов и их шифрование
            JSONObject jsonObject = JsonDataSaver.TryLoadChatsWithoutRead(context);
            Gson gson = new Gson();
            String jsonString = gson.toJson(jsonObject);
            byte[] jsonBytes = jsonString.getBytes(StandardCharsets.UTF_8);

            byte[] encrypted = cipher.doFinal(jsonBytes);
            String encryptedString = Base64.getEncoder().encodeToString(encrypted);

            result = loginHash + " " + passwordHash + " " + encryptedString;
        } else {
            // Возврат только хэшей
            result = loginHash + " " + passwordHash;
        }
        return result;
    }

    // Преобразование байтового массива в шестнадцатеричную строку
    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    // Расшифровка информации о пользователе с использованием логина и пароля, возврат объекта JSONObject
    public static JSONObject DecryptUser(String login, String password, String encryptedString, Context context) throws Exception {
        // Генерация ключа из логина и пароля
        String key = login + password;
        MessageDigest sha = MessageDigest.getInstance("SHA-256");
        byte[] keyBytes = key.getBytes(StandardCharsets.UTF_8);
        keyBytes = sha.digest(keyBytes);
        keyBytes = Arrays.copyOf(keyBytes, 16);

        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, "AES");

        // Инициализация шифра AES для расшифровки
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, secretKey);

        // Декодирование строки Base64 и расшифровка
        byte[] encryptedBytes = Base64.getDecoder().decode(encryptedString);
        byte[] decryptedBytes = cipher.doFinal(encryptedBytes);

        // Преобразование расшифрованного байтового массива в JSON строку и её парсинг
        String jsonString = new String(decryptedBytes, StandardCharsets.UTF_8);
        Gson gson = new Gson();
        JsonObject jsonObject = gson.fromJson(jsonString, JsonObject.class);

        // Преобразование JsonObject в JSONObject
        JSONObject decrypted = new JSONObject(jsonObject.toString());

        return decrypted;
    }
}
