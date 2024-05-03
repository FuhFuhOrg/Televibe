package com.example.teletypesha.fragments;

import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.teletypesha.R;
import com.example.teletypesha.adapters.ChatAdapter;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.Messange;

import java.util.ArrayList;

public class ChatsFragment extends Fragment {
    private RecyclerView recyclerView;
    ArrayList<Chat> chatList = new ArrayList<>();
    ChatAdapter adapter;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_chats, container, false);
        recyclerView = view.findViewById(R.id.recycler);

        GetFictChats();
        CreateItemList();

        return view;
    }

    private void GetFictChats(){
        for (int i = 0; i < 10; i++){
            ArrayList<Messange> messages = new ArrayList<>();
            messages.add(new Messange("Anton", "hi"));
            messages.add(new Messange("Victor", "hi"));
            chatList.add(new Chat(messages, "Anton", 14142421));
        }
    }

    private void CreateItemList(){
        DisplayMetrics displayMetrics = new DisplayMetrics();
        requireActivity().getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
        adapter = new ChatAdapter(chatList, displayMetrics.widthPixels);

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
}