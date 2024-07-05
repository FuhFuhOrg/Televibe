package com.example.teletypesha.itemClass;

import java.util.ArrayList;

public interface SharedViewByChatsListener {
    void onChatListChanged(ArrayList<Chat> newChatList);

    void onSelectChatChanged(Chat newSelectChat);
}
