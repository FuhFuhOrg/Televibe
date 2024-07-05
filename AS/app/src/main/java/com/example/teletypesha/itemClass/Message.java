package com.example.teletypesha.itemClass;

import java.time.LocalDateTime;

public class Message {
    public byte[] text;
    public Integer author, messageId;
    LocalDateTime sendTime;
    // УБРАТЬ
    boolean isRead;
    long timeInSecond = -1;

    public Message(Integer author, Integer messageId, byte[] text, LocalDateTime sendTime, boolean isRead){
        this.sendTime = sendTime;
        this.messageId = messageId;
        this.author = author;
        this.text = text;
    }

    // УБРАТЬ
    public boolean GetIsReaded(){
        return isRead;
    }

    // УБРАТЬ
    public void SetIsReaded(boolean isRead){
        this.isRead = isRead;
    }

    public void SetTimeInSeconds(long timeInSecond){
        this.timeInSecond = timeInSecond;
    }

    public long GetTimeInSeconds(){
        return timeInSecond;
    }
}
