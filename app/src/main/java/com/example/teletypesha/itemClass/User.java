package com.example.teletypesha.itemClass;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.Pair;

import com.example.teletypesha.crypt.Crypt;

import java.security.PrivateKey;
import java.security.PublicKey;

public class User {
    private String name;
    private PublicKey publicKey;
    private PrivateKey privateKey;

    public User(String name){
        GenerateCrypt();
        this.name = name;
    }

    public User(String name, PublicKey publicKey){
        this.name = name;
        this.publicKey = publicKey;
    }

    public void GenerateCrypt(){
        Pair<PrivateKey, PublicKey> keys;
        try {
            keys = Crypt.PublicPrivateKeyGeneration();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        privateKey = keys.first;
        publicKey = keys.second;
    }

    public void SetPublicKey(PublicKey publicKey){
        this.publicKey = publicKey;
    }

    public PublicKey GetPublicKey(){
        return publicKey;
    }

    public String GetName(){
        return name;
    }

    public void SetName(String name){
        this.name = name;
    }

    public byte[] Encrypt(String msg){
        try {
            return Crypt.Encryption(msg, privateKey);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public byte[] EncryptImage(Context context, byte[] msg){
        try {
            return Crypt.EncryptionImage(context, msg, privateKey);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public String Decrypt(byte[] msg){
        if (publicKey == null){
            return "KEY NOT FOUND";
        }
        try {
            return Crypt.Decrypt(msg, publicKey);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public Bitmap DecryptImage(byte[] msg){
        if (publicKey == null){
            return null;
        }
        try {
            return Crypt.DecryptImage(msg, publicKey);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
