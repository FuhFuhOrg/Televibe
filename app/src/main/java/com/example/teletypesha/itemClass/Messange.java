package com.example.teletypesha.itemClass;

import java.time.LocalDateTime;

public class Messange {
    public String text;
    public int author;
    LocalDateTime sendTime;

    public Messange(int author, String text, LocalDateTime sendTime){
        this.sendTime = sendTime;
        this.author = author;
        this.text = text;
    }
}
