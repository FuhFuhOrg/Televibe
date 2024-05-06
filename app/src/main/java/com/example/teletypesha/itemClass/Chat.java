package com.example.teletypesha.itemClass;

import android.widget.ImageButton;

import java.util.ArrayList;

public class Chat {
    Integer yourId;
    ArrayList<Messange> messanges;
    ArrayList<Integer> anotherUsers;
    Integer secondUserHashId;

    public Chat(Integer yourId, ArrayList<Messange> messanges, ArrayList<Integer> anotherUsers, Integer secondUserHashId){
        this.yourId = yourId;
        this.messanges = messanges;
        this.anotherUsers = anotherUsers;
        this.secondUserHashId = secondUserHashId;
    }

    public Integer GetYourId(){
        return yourId;
    }

    public ArrayList<Integer> getName(){
        return anotherUsers;
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
