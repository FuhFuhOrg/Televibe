package com.example.teletypesha.itemClass;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import java.util.ArrayList;

public class SharedViewByChats extends ViewModel {
    private final MutableLiveData<ArrayList<Chat>> chatList = new MutableLiveData<>();
    private final MutableLiveData<Chat> selectChat = new MutableLiveData<>();

    public void setChatList(ArrayList<Chat> chatList) {
        this.chatList.setValue(chatList);
    }

    public LiveData<ArrayList<Chat>> getChatList() {
        return chatList;
    }

    public void setSelectChat(Chat selectChat) {
        this.selectChat.setValue(selectChat);
    }

    public LiveData<Chat> getSelectChat() {
        return selectChat;
    }
}