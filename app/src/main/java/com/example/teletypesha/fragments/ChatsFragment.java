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
import com.example.teletypesha.activitys.MainActivity;
import com.example.teletypesha.adapters.ChatListAdapter;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.Messange;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Random;

public class ChatsFragment extends Fragment {
    private RecyclerView recyclerView;
    ArrayList<Chat> chatList = new ArrayList<>();
    ChatListAdapter adapter;

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
            Integer yourId = (new Random()).nextInt();

            ArrayList<Integer> users = new ArrayList<>();
            users.add((new Random()).nextInt());
            users.add((new Random()).nextInt());

            ArrayList<Messange> messages = new ArrayList<>();
            messages.add(new Messange(users.get((new Random()).nextInt(users.size())), "hi", LocalDateTime.now()));
            messages.add(new Messange(users.get((new Random()).nextInt(users.size())), "hi", LocalDateTime.now()));
            messages.add(new Messange(users.get((new Random()).nextInt(users.size())), "hi", LocalDateTime.now()));
            messages.add(new Messange(users.get((new Random()).nextInt(users.size())), "hi", LocalDateTime.now()));
            messages.add(new Messange(users.get((new Random()).nextInt(users.size())), "hi", LocalDateTime.now()));

            messages.add(new Messange(yourId, "hi", LocalDateTime.now()));
            messages.add(new Messange(yourId, "hi", LocalDateTime.now()));

            chatList.add(new Chat(yourId, messages, users, (new Random()).nextInt()));
        }
    }

    private void CreateItemList(){
        DisplayMetrics displayMetrics = new DisplayMetrics();
        requireActivity().getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
        adapter = new ChatListAdapter(chatList, displayMetrics.widthPixels, (MainActivity) requireActivity());

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