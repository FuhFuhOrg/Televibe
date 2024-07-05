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
import com.example.teletypesha.itemClass.Message;
import com.example.teletypesha.itemClass.SharedViewByChats;
import com.example.teletypesha.itemClass.SharedViewByChatsListener;
import com.example.teletypesha.itemClass.User;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;

public class ChatsFragment extends Fragment implements SharedViewByChatsListener {
    private RecyclerView recyclerView;
    private ChatListAdapter adapter;

    // Создает и настраивает представление фрагмента
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_chats, container, false);
        recyclerView = view.findViewById(R.id.recycler);
        SharedViewByChats.setListener(this);
        CreateItemList(SharedViewByChats.getChatList());
        return view;
    }

    // Настройка представления фрагмента после его создания
    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
    }

    // Создание фиктивных чатов для тестирования
    public static void CreateFictChats(ArrayList<Chat> chatList) {
        Random random = new Random();
        for (int i = 0; i < 10; i++) {
            Integer yourId = random.nextInt();

            HashMap<Integer, User> users = new HashMap<>();
            for (int j = 0; j < 2 + Math.abs(random.nextInt() % 4); j++) {
                users.put(random.nextInt(), new User("Pip" + j));
            }
            users.put(yourId, new User("You"));

            ArrayList<Integer> keys = new ArrayList<>(users.keySet());
            ArrayList<Message> messages = new ArrayList<>();
            for (int j = 0; j < 5 + Math.abs(random.nextInt() % 25); j++) {
                Integer randomUserId = keys.get(random.nextInt(keys.size()));
                messages.add(new Message(randomUserId, -1, users.get(randomUserId).Encrypt("hi"), LocalDateTime.now(), false));
            }

            chatList.add(new Chat(yourId, messages, users, String.valueOf(random.nextInt()), ""));
            if (random.nextInt() > 0) {
                chatList.get(chatList.size() - 1).SetLabel("Amogus");
            }
        }
    }

    // Создание и настройка адаптера для списка чатов
    private void CreateItemList(ArrayList<Chat> chats) {
        DisplayMetrics displayMetrics = new DisplayMetrics();
        requireActivity().getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
        adapter = new ChatListAdapter(chats, displayMetrics.widthPixels, (MainActivity) requireActivity());

        // Установка адаптера для RecyclerView на главном потоке
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

    // Обновление списка чатов при изменении
    @Override
    public void onChatListChanged(ArrayList<Chat> newChatList) {
        CreateItemList(newChatList);
    }

    // Обработка изменений выбранного чата (пока пустая)
    @Override
    public void onSelectChatChanged(Chat newSelectChat) {
        // Пустой метод для будущей реализации
    }
}
