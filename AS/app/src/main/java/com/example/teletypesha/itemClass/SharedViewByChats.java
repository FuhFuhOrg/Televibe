package com.example.teletypesha.itemClass;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import java.util.ArrayList;
import java.util.Objects;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Objects;
import java.util.Queue;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Objects;
import java.util.Queue;


// Работает не всегда
public class SharedViewByChats {
    private static ArrayList<Chat> chatList;
    private static Chat selectChat;
    private static SharedViewByChatsListener listener;
    private static Queue<Object> pendingChanges = new LinkedList<>();

    public static void setChatList(ArrayList<Chat> cl) {
        chatList = cl;
        if (listener != null) {
            listener.onChatListChanged(cl);
        } else {
            pendingChanges.add(cl);
        }

        handlePendingSelectChat();
    }

    public static ArrayList<Chat> getChatList() {
        return chatList;
    }

    public static void setSelectChat(Chat sc) {
        selectChat = sc;
        if (listener != null) {
            listener.onSelectChatChanged(sc);
        } else {
            pendingChanges.add(sc);
        }
    }

    public static Chat getSelectChat() {
        return selectChat;
    }

    public static void setListener(SharedViewByChatsListener l) {
        listener = l;
        changeListener();
    }

    private static void changeListener() {
        if(listener == null)
            return;
        // Обработка всех ожидающих изменений
        while (!pendingChanges.isEmpty()) {
            Object change = pendingChanges.poll();
            if (change instanceof ArrayList) {
                listener.onChatListChanged((ArrayList<Chat>) change);
            } else if (change instanceof Chat) {
                listener.onSelectChatChanged((Chat) change);
            }
        }
    }

    private static void handlePendingSelectChat() {
        if (selectChat == null) {
            return;
        }

        if (chatList == null || chatList.isEmpty()) {
            return;
        }

        for (Chat chat : chatList) {
            if (Objects.equals(chat.GetChatId(), selectChat.GetChatId())) {
                setSelectChat(chat);
                break;
            }
        }
    }

    public static boolean ChatIsExist(String id){
        for (Chat chat:
             chatList) {
            if(Objects.equals(chat.chatId, id)){
                return true;
            }
        }
        return false;
    }
}
