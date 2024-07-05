package com.example.teletypesha.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Adapter;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.example.teletypesha.R;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.SharedViewByChats;
import com.example.teletypesha.itemClass.User;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class SettingsChatFragment extends Fragment {

    // Создание и настройка представления фрагмента
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.chat_menu_fragment, container, false);

        // Инициализация настроек метки чата и пользователей
        UserSetter(view);
        ChatLabelSetter(view);

        return view;
    }

    // Настройка редактирования метки чата
    private void ChatLabelSetter(View view){
        EditText editTextChatLabel = view.findViewById(R.id.editText_chat_menu_chat_label);
        Button buttonChatLabel = view.findViewById(R.id.button_chat_menu_chat_label);

        // Установка текущей метки выбранного чата в EditText
        for (Chat chat : SharedViewByChats.getChatList()) {
            if (Objects.equals(chat.GetChatId(), SharedViewByChats.getSelectChat().GetChatId())){
                editTextChatLabel.setText(chat.GetLabel());
                break;
            }
        }

        // Обработка нажатия на кнопку для обновления метки чата
        buttonChatLabel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ArrayList<Chat> chats = SharedViewByChats.getChatList();
                for (Chat chat : chats) {
                    if (Objects.equals(chat.GetChatId(), SharedViewByChats.getSelectChat().GetChatId())){
                        chat.SetLabel(String.valueOf(editTextChatLabel.getText()));
                        break;
                    }
                }
                SharedViewByChats.setChatList(chats); // Обновление списка чатов
            }
        });
    }

    // Настройка редактирования пользователей в чате
    private void UserSetter(View view){
        EditText editTextUsers = view.findViewById(R.id.editText_chat_menu_user);
        Button buttonUsers = view.findViewById(R.id.button_chat_menu_user);
        Spinner spinnerUsers = view.findViewById(R.id.spinner_chat_menu_user);

        HashMap<Integer, User> usersHashMap = SharedViewByChats.getSelectChat().GetUsers();
        ArrayList<String> usersList = getUsersListFromHashMap(usersHashMap);

        // Настройка адаптера для выпадающего списка пользователей
        ArrayAdapter<String> spinnerAdapter = new ArrayAdapter<>(getContext(), android.R.layout.simple_spinner_item, usersList);
        spinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinnerUsers.setAdapter(spinnerAdapter);

        // Обработка выбора пользователя из выпадающего списка
        spinnerUsers.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                String selectedUserName = (String) parent.getItemAtPosition(position);
                editTextUsers.setText(selectedUserName);

                int userId = getUserIdFromName(selectedUserName, usersHashMap);
                editTextUsers.setTag(userId); // Сохранение ID выбранного пользователя
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
                // Не требуется обработка
            }
        });

        // Обработка нажатия на кнопку для обновления имени пользователя
        buttonUsers.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int userId = (int) editTextUsers.getTag();
                String newName = editTextUsers.getText().toString();
                updateUserInHashMap(userId, newName, usersHashMap, spinnerAdapter); // Обновление данных пользователя
            }
        });
    }

    // Получение списка имен пользователей из HashMap
    private ArrayList<String> getUsersListFromHashMap(HashMap<Integer, User> usersHashMap) {
        ArrayList<String> usersList = new ArrayList<>();
        for (Map.Entry<Integer, User> entry : usersHashMap.entrySet()) {
            User user = entry.getValue();
            usersList.add(user.GetName());
        }
        return usersList;
    }

    // Получение ID пользователя по его имени
    private int getUserIdFromName(String userName, HashMap<Integer, User> usersHashMap) {
        for (Map.Entry<Integer, User> entry : usersHashMap.entrySet()) {
            User user = entry.getValue();
            if (user.GetName().equals(userName)) {
                return entry.getKey();
            }
        }
        return -1; // Возвращение -1 если пользователь не найден
    }

    // Обновление данных пользователя в HashMap и адаптере
    private void updateUserInHashMap(int userId, String newName, HashMap<Integer, User> usersHashMap, ArrayAdapter<String> spinnerAdapter) {
        User userToUpdate = usersHashMap.get(userId);
        if (userToUpdate != null) {
            userToUpdate.SetName(newName);
            usersHashMap.put(userId, userToUpdate);
            spinnerAdapter.clear();
            spinnerAdapter.addAll(getUsersListFromHashMap(usersHashMap));
            spinnerAdapter.notifyDataSetChanged(); // Обновление данных в адаптере
        }
    }
}
