package com.example.teletypesha.fragments;

import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.Observer;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.teletypesha.R;
import com.example.teletypesha.activitys.MainActivity;
import com.example.teletypesha.adapters.ChatAdapter;
import com.example.teletypesha.adapters.ChatListAdapter;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.SharedViewByChats;
import com.example.teletypesha.itemClass.SharedViewByChatsListener;
import com.example.teletypesha.netCode.NetServerController;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.concurrent.CompletableFuture;

public class SingleChatFragment extends Fragment implements SharedViewByChatsListener {
    private RecyclerView recyclerView;
    ChatAdapter adapter;



    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_single_chat, container, false);
        recyclerView = view.findViewById(R.id.chat_recycler);
        SharedViewByChats.setListener(this);
        CreateMessangesList(SharedViewByChats.getSelectChat());
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
    }



    private void CreateMessangesList(Chat chat){
        DisplayMetrics displayMetrics = new DisplayMetrics();
        requireActivity().getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
        adapter = new ChatAdapter(chat, displayMetrics.widthPixels, (MainActivity) requireActivity());

        requireActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                recyclerView.setLayoutManager(new LinearLayoutManager(requireContext()));
                Log.i("Debug", recyclerView.toString());
                recyclerView.setAdapter(adapter);
                Log.i("Debug", "adapter set");
            }
        });
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
