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
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.teletypesha.R;
import com.example.teletypesha.activitys.MainActivity;
import com.example.teletypesha.adapters.ChatAdapter;
import com.example.teletypesha.adapters.ChatListAdapter;
import com.example.teletypesha.itemClass.Chat;

import java.util.ArrayList;

public class SingleChatFragment extends Fragment {
    Chat chat;
    private RecyclerView recyclerView;
    ChatAdapter adapter;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_single_chat, container, false);
        recyclerView = view.findViewById(R.id.chat_recycler);

        CreateMessangesList();

        return view;
    }

    public void SetChat(Chat chat){
        this.chat = chat;
    }

    private void CreateMessangesList(){
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
}
