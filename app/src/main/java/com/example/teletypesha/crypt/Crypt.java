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

    public static byte[] EncryptionImage(Context context, byte[] msg, PrivateKey privateKey) throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        SecretKey secretKey = keyGen.generateKey();

        Cipher aesCipher = Cipher.getInstance("AES");
        aesCipher.init(Cipher.ENCRYPT_MODE, secretKey);

        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, "Encryption Progress", NotificationManager.IMPORTANCE_LOW);
            notificationManager.createNotificationChannel(channel);
        }

        int totalBytesProcessed = 0;
        int chunkSize = 1024 * 1024; // 1024 KB
        byte[] buffer = new byte[chunkSize];
        int bytesRead = 0;

        ByteArrayOutputStream encryptedStream = new ByteArrayOutputStream();

        for (int offset = 0; offset < msg.length; offset += chunkSize) {
            bytesRead = Math.min(chunkSize, msg.length - offset);
            System.arraycopy(msg, offset, buffer, 0, bytesRead);
            byte[] encryptedChunk = aesCipher.doFinal(buffer, 0, bytesRead);
            encryptedStream.write(encryptedChunk);
            totalBytesProcessed += bytesRead;

            if (totalBytesProcessed % chunkSize == 0) {
                // Update Notification
                String notificationText = totalBytesProcessed + " bytes encrypted";
                Notification notification = new NotificationCompat.Builder(context, CHANNEL_ID)
                        .setContentTitle("Encryption in Progress")
                        .setContentText(notificationText)
                        .setSmallIcon(R.drawable.ic_encryption)
                        .setProgress(msg.length, totalBytesProcessed, false)
                        .build();
                notificationManager.notify(NOTIFICATION_ID, notification);
            }
        }

        byte[] encryptedMsg = encryptedStream.toByteArray();

        Cipher rsaCipher = Cipher.getInstance("RSA");
        rsaCipher.init(Cipher.WRAP_MODE, privateKey);
        byte[] encryptedKey = rsaCipher.wrap(secretKey);

        byte[] combined = new byte[encryptedKey.length + encryptedMsg.length];
        System.arraycopy(encryptedKey, 0, combined, 0, encryptedKey.length);
        System.arraycopy(encryptedMsg, 0, combined, encryptedKey.length, encryptedMsg.length);

        // Final notification
        String finalNotificationText = "Encryption complete: " + combined.length + " bytes";
        Notification finalNotification = new NotificationCompat.Builder(context, CHANNEL_ID)
                .setContentTitle("Encryption Complete")
                .setContentText(finalNotificationText)
                .setSmallIcon(R.drawable.ic_encryption)
                .setProgress(0, 0, false)
                .build();
        notificationManager.notify(NOTIFICATION_ID, finalNotification);

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

    public static Bitmap DecryptImage(byte[] combined, PublicKey publicKey) throws Exception {
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

        Bitmap bitmap = BitmapFactory.decodeByteArray(decryptedMsg, 0, decryptedMsg.length);

        return bitmap;
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

    public static String CriptUser(String login, String password, Context context, Boolean returnChats) throws Exception {
        MessageDigest sha = MessageDigest.getInstance("SHA-256");
        byte[] loginHashBytes = sha.digest(login.getBytes(StandardCharsets.UTF_8));
        String loginHash = bytesToHex(loginHashBytes);

        byte[] passwordHashBytes = sha.digest(password.getBytes(StandardCharsets.UTF_8));
        String passwordHash = bytesToHex(passwordHashBytes);

        String key = login + password;
        byte[] keyBytes = key.getBytes(StandardCharsets.UTF_8);
        keyBytes = sha.digest(keyBytes);
        keyBytes = Arrays.copyOf(keyBytes, 16);

        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, "AES");

        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, secretKey);

        String result;
        if(returnChats) {
            JSONObject jsonObject = JsonDataSaver.TryLoadChatsWithoutRead(context);
            Gson gson = new Gson();
            String jsonString = gson.toJson(jsonObject);
            byte[] jsonBytes = jsonString.getBytes(StandardCharsets.UTF_8);

            byte[] encrypted = cipher.doFinal(jsonBytes);
            String encryptedString = Base64.getEncoder().encodeToString(encrypted);

            result = loginHash + " " + passwordHash + " " + encryptedString;
        }
        else{
            result = loginHash + " " + passwordHash;
        }
        return result;
    }

    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }



    public static JSONObject DecryptUser(String login, String password, String encryptedString, Context context) throws Exception {
        String key = login + password;
        MessageDigest sha = MessageDigest.getInstance("SHA-256");
        byte[] keyBytes = key.getBytes(StandardCharsets.UTF_8);
        keyBytes = sha.digest(keyBytes);
        keyBytes = Arrays.copyOf(keyBytes, 16);

        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, "AES");

        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, secretKey);

        byte[] encryptedBytes = Base64.getDecoder().decode(encryptedString);

        byte[] decryptedBytes = cipher.doFinal(encryptedBytes);

        String jsonString = new String(decryptedBytes, StandardCharsets.UTF_8);

        Gson gson = new Gson();
        JsonObject jsonObject = gson.fromJson(jsonString, JsonObject.class);

        JSONObject decrypted = new JSONObject(jsonObject.toString());

        return decrypted;
    }

}