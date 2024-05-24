package com.example.teletypesha.fragments;

import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.teletypesha.R;
import com.example.teletypesha.activitys.MainActivity;
import com.example.teletypesha.adapters.ChatAdapter;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.Message;
import com.example.teletypesha.itemClass.SharedViewByChats;
import com.example.teletypesha.itemClass.SharedViewByChatsListener;

import java.util.ArrayList;
import java.util.Objects;

public class SingleChatFragment extends Fragment implements SharedViewByChatsListener {
    private RecyclerView recyclerView;
    ChatAdapter adapter;
    EditText editText;
    private Message editedMessage;
    private boolean isEdited = false;



    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_single_chat, container, false);
        recyclerView = view.findViewById(R.id.chat_recycler);
        editText = view.findViewById(R.id.message_edit_text);
        SharedViewByChats.setListener(this);
        CreateMessangesList(SharedViewByChats.getSelectChat());

        Button sendButton = view.findViewById(R.id.send_button);
        sendButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isEdited){
                    byte[] messange = SharedViewByChats.getSelectChat().GetUser(
                            SharedViewByChats.getSelectChat().GetYourId()).Encrypt(String.valueOf(editText.getText()));
                    ((MainActivity) requireActivity()).EditMessage(editedMessage, messange);
                }else{
                    ((MainActivity) requireActivity()).SendMessage();
                }
            }
        });

        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
    }



    public void scrollToLastUnreadMessage(Chat chat) {
        // Получите индекс последнего непрочитанного сообщения
        int lastUnreadIndex = -1;
        ArrayList<Message> messages = chat.GetMessanges();
        for (int i = messages.size() - 1; i >= 0; i--) {
            if (!messages.get(i).GetIsReaded()) {
                lastUnreadIndex = i;
                break;
            }
        }

        // Если найдено непрочитанное сообщение, прокрутите Recycler к этому сообщению
        if (lastUnreadIndex != -1) {
            int recyclerViewIndex = lastUnreadIndex;
            recyclerView.scrollToPosition(recyclerViewIndex);
        }
    }


    private void CreateMessangesList(Chat chat){
        DisplayMetrics displayMetrics = new DisplayMetrics();
        requireActivity().getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
        adapter = new ChatAdapter(chat, displayMetrics.widthPixels, (MainActivity) requireActivity(), this);

        requireActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                recyclerView.setLayoutManager(new LinearLayoutManager(requireContext()));
                Log.i("Debug", recyclerView.toString());
                recyclerView.setAdapter(adapter);
                Log.i("Debug", "adapter set");
                scrollToLastUnreadMessage(chat);
            }
        });
    }

    public void StartEditMessage(Chat chat, Message message){
        if(Objects.equals(message.author, chat.GetYourId())) {
            editedMessage = message;
            isEdited = true;
            editText.setText(chat.GetUser(chat.GetYourId()).Decrypt(message.text));
        }
    }









    // Подписки
    @Override
    public void onChatListChanged(ArrayList<Chat> newChatList) {
        //
    }

    @Override
    public void onSelectChatChanged(Chat newSelectChat) {
        CreateMessangesList(newSelectChat);
    }
}
