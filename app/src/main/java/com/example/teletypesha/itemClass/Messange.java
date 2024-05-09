package com.example.teletypesha.itemClass;

import android.util.Pair;

import java.time.LocalDateTime;

public class Messange {
    public String text;
    public Integer author;
    LocalDateTime sendTime;

    public Messange(Integer author, String text, LocalDateTime sendTime){
        this.sendTime = sendTime;
        this.author = author;
        this.text = text;
    }
}
