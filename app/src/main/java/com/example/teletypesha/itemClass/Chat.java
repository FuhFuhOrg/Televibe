package com.example.teletypesha.itemClass;

import java.util.ArrayList;
import java.util.HashMap;

public class Chat {
    Integer yourId;
    ArrayList<Messange> messages;
    HashMap<Integer, User> users;
    String label, chatId;

    public Chat(Integer yourId, ArrayList<Messange> messages, HashMap<Integer, User> users, String chatId){
        this.yourId = yourId;
        this.messages = messages;
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
        if(messages.size() > 0){
            return messages.get(messages.size() - 1);
        }
        else{
            return null;
        }
    }

    public ArrayList<Messange> GetMessanges(){
        return messages;
    }
}
