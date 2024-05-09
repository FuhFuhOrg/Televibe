package com.example.teletypesha.itemClass;

import java.time.LocalDateTime;

public class Messange {
    public byte[] text;
    public Integer author;
    LocalDateTime sendTime;

    public Messange(Integer author, byte[] text, LocalDateTime sendTime){
        this.sendTime = sendTime;
        this.author = author;
        this.text = text;
    }
}
