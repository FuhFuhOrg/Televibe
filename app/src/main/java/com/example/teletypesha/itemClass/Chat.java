package com.example.teletypesha.itemClass;

import android.widget.ImageButton;

import java.util.ArrayList;

public class Chat {
    ArrayList<Messange> messanges;
    String secondUserName;
    Integer secondUserHashId;

    public Chat(ArrayList<Messange> messanges, String secondUserName, Integer secondUserHashId){
        this.messanges = messanges;
        this.secondUserName = secondUserName;
        this.secondUserHashId = secondUserHashId;
    }

    public String getName(){
        return secondUserName;
    }
}
