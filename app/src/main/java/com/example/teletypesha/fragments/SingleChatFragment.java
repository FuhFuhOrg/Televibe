package com.example.teletypesha.fragments;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.os.FileUtils;
import android.provider.MediaStore;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;

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
    private ChatAdapter adapter;
    private EditText editText;
    private Message editedMessage;
    private boolean isEdited = false;
    private static final int PICK_FILE_REQUEST = 1;

    // Создание и настройка представления фрагмента
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
                if (isEdited) {
                    byte[] messange = SharedViewByChats.getSelectChat().GetUser(
                            SharedViewByChats.getSelectChat().GetYourId()).Encrypt(String.valueOf(editText.getText()));
                    ((MainActivity) requireActivity()).EditMessage(editedMessage, messange);
                    isEdited = false;
                } else {
                    ((MainActivity) requireActivity()).SendMessage();
                }
            }
        });

        Button sendButtonSkrepochka = view.findViewById(R.id.send_button_screpochka);
        sendButtonSkrepochka.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
                intent.setType("*/*");
                startActivityForResult(intent, PICK_FILE_REQUEST);
            }
        });

        TextView chatMenuName = view.findViewById(R.id.chat_menu_name);
        chatMenuName.setText(SharedViewByChats.getSelectChat().GetLabel());

        return view;
    }

    // Обработка результата выбора файла
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == PICK_FILE_REQUEST && resultCode == Activity.RESULT_OK) {
            if (data != null && data.getData() != null) {
                Uri fileUri = data.getData();
                ((MainActivity) requireActivity()).SendMessageSkrepochka(fileUri);
            }
        }
    }

    // Получение реального пути к файлу из URI
    private String getRealPathFromURI(Context context, Uri contentUri) {
        String filePath;
        Cursor cursor = null;
        try {
            String[] projection = {MediaStore.Images.Media.DATA};
            cursor = context.getContentResolver().query(contentUri, projection, null, null, null);
            if (cursor != null && cursor.moveToFirst()) {
                int columnIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
                filePath = cursor.getString(columnIndex);
            } else {
                filePath = contentUri.getPath();
            }
        } finally {
            if (cursor != null) {
                cursor.close();
            }
        }
        return filePath;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
    }

    // Прокрутка к последнему непрочитанному сообщению
    public void scrollToLastUnreadMessage(Chat chat) {
        int lastUnreadIndex = -1;
        ArrayList<Message> messages = chat.GetMessanges();
        for (int i = messages.size() - 1; i >= 0; i--) {
            if (!messages.get(i).GetIsReaded()) {
                lastUnreadIndex = i;
                break;
            }
        }

        if (lastUnreadIndex != -1) {
            recyclerView.scrollToPosition(lastUnreadIndex);
        }
    }

    // Создание списка сообщений и настройка адаптера
    private void CreateMessangesList(Chat chat) {
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

    // Начало редактирования сообщения
    public void StartEditMessage(Chat chat, Message message) {
        if (Objects.equals(message.author, chat.GetYourId())) {
            editedMessage = message;
            isEdited = true;
            editText.setText(chat.GetUser(chat.GetYourId()).Decrypt(message.text));
        }
    }

    // Обработка изменения списка чатов
    @Override
    public void onChatListChanged(ArrayList<Chat> newChatList) {
        // Пустой метод для будущей реализации
    }

    // Обработка изменения выбранного чата
    @Override
    public void onSelectChatChanged(Chat newSelectChat) {
        if (newSelectChat.isChanged) {
            newSelectChat.isChanged = false;
            CreateMessangesList(newSelectChat);
        }
    }
}
