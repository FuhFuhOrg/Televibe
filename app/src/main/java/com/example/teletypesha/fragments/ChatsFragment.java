package com.example.teletypesha.fragments;

import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.Pair;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.Observer;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.teletypesha.R;
import com.example.teletypesha.activitys.MainActivity;
import com.example.teletypesha.adapters.ChatListAdapter;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.Messange;
import com.example.teletypesha.itemClass.User;
import com.example.teletypesha.jsons.JsonDataSaver;
import com.example.teletypesha.netCode.NetServerController;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.Set;

public class ChatsFragment extends Fragment {
    private RecyclerView recyclerView;
    ArrayList<Chat> chatList = new ArrayList<>();
    ChatListAdapter adapter;
    private LiveData<ArrayList<Chat>> chatListLiveData;

    public void setChatListLiveData(LiveData<ArrayList<Chat>> chatListLiveData) {
        this.chatListLiveData = chatListLiveData;
    }


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_chats, container, false);
        recyclerView = view.findViewById(R.id.recycler);

        if (getActivity() instanceof MainActivity) {
            MainActivity mainActivity = (MainActivity) getActivity();
            setChatListLiveData(mainActivity.GetSharedViewByChats().getChatList());
        }

        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        chatListLiveData.observe(getViewLifecycleOwner(), new Observer<ArrayList<Chat>>() {
            @Override
            public void onChanged(ArrayList<Chat> newChatList) {
                chatList.clear();
                chatList.addAll(newChatList);
                CreateItemList();
            }
        });
    }

    public static void CreateFictChats(ArrayList<Chat> chatList){
        Random random = new Random();
        for (int i = 0; i < 10; i++){
            Integer yourId = random.nextInt();

            HashMap<Integer, User> users = new HashMap<>();
            for (int j = 0; j < 2 + Math.abs(random.nextInt() % 4); j++){
                users.put(random.nextInt(), new User("Pip" + j));
            }
            users.put(yourId, new User("You"));

            ArrayList<Integer> keys = new ArrayList<>(users.keySet());
            ArrayList<Messange> messages = new ArrayList<>();
            for (int j = 0; j < 5 + Math.abs(random.nextInt() % 25); j++){
                Integer randomUserId = keys.get(random.nextInt(keys.size()));
                messages.add(new Messange(randomUserId, -1, users.get(randomUserId).Encrypt("hi"), LocalDateTime.now()));
            }

            chatList.add(new Chat(yourId, messages, users, String.valueOf(random.nextInt())));
            if(random.nextInt() > 0){
                chatList.get(chatList.size() - 1).SetLabel("Amogus");
            }
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