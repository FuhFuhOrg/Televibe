package com.example.teletypesha.itemClass;

import java.time.LocalDateTime;

public class Messange {
    public byte[] text;
    public Integer author, messageId;
    LocalDateTime sendTime;

    public Messange(Integer author, Integer messageId, byte[] text, LocalDateTime sendTime){
        this.sendTime = sendTime;
        this.messageId = messageId;
        this.author = author;
        this.text = text;
    }
}
