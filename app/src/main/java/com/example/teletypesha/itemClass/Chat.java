package com.example.teletypesha.itemClass;

import android.widget.ImageButton;

import java.util.ArrayList;
import java.util.HashMap;

public class Chat {
    Integer yourId;
    ArrayList<Messange> messanges;
    HashMap<Integer, User> users;
    String label, chatId;

    public Chat(Integer yourId, ArrayList<Messange> messanges, HashMap<Integer, User> users, String chatId){
        this.yourId = yourId;
        this.messanges = messanges;
        this.users = users;
        this.chatId = chatId;
    }

    public Integer GetYourId(){
        return yourId;
    }

    public String GetLabel(){
        if(label != null){
            return label;
        }
        else{
            return chatId;
        }
    }

    public void SetLabel(String label){
        this.label = label;
    }

    public HashMap<Integer, User> GetUsers(){
        return users;
    }

    public User GetUser(int id){
        return users.get(id);
    }

    public Messange getLastMsg(){
        if(messanges.size() > 0){
            return messanges.get(messanges.size() - 1);
        }
        else{
            return null;
        }
    }

    public ArrayList<Messange> GetMessanges(){
        return messanges;
    }
}
