package com.example.teletypesha.itemClass;

import android.util.Pair;

import com.example.teletypesha.crypt.Crypt;

import java.security.PrivateKey;
import java.security.PublicKey;

public class User {
    private String name;
    private PublicKey publicKey;
    private PrivateKey privateKey;

    public User(String name){
        this.name = name;
        GenerateCrypt();
    }

    public User(){

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

    public String Decrypt(byte[] msg){
        try {
            return Crypt.Decrypt(msg, publicKey);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
