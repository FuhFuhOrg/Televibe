package com.example.teletypesha.crypt;

import android.util.Pair;

import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.util.Base64;

import javax.crypto.Cipher;

public final class Crypt {

    public static Pair<PrivateKey, PublicKey> PublicPrivateKeyGeneration(String msg) throws Exception {
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
        keyPairGenerator.initialize(2048);
        KeyPair keyPair = keyPairGenerator.generateKeyPair();
        PrivateKey privateKey = keyPair.getPrivate();
        PublicKey publicKey = keyPair.getPublic();
        Pair<PrivateKey, PublicKey> pk = new Pair<>(privateKey, publicKey);
        return pk;
    }

    public static byte[] Encryption(String msg, PublicKey privateKey) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.ENCRYPT_MODE, privateKey);

        return cipher.doFinal(msg.getBytes());
    }

    public static String Decrypt(String encryptedMsg, PrivateKey publicKey) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.DECRYPT_MODE, publicKey);
        byte[] decodedMsg = Base64.getDecoder().decode(encryptedMsg);
        byte[] decryptedMsg = cipher.doFinal(decodedMsg);
        return new String(decryptedMsg);
    }
}
