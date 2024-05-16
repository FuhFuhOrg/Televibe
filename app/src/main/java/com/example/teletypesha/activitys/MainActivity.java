package com.example.teletypesha.activitys;

import static com.example.teletypesha.fragments.ChatsFragment.CreateFictChats;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.util.Log;
import android.util.Pair;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;
import android.widget.ToggleButton;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModelProvider;

import com.example.teletypesha.R;
import com.example.teletypesha.crypt.Crypt;
import com.example.teletypesha.fragments.AddChatFragment;
import com.example.teletypesha.fragments.ChatsFragment;
import com.example.teletypesha.fragments.CreateChatFragment;
import com.example.teletypesha.fragments.SettingsFragment;
import com.example.teletypesha.fragments.SingleChatFragment;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.Messange;
import com.example.teletypesha.itemClass.SharedViewByChats;
import com.example.teletypesha.itemClass.User;
import com.example.teletypesha.jsons.JsonDataSaver;
import com.example.teletypesha.netCode.NetServerController;

import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.CompletableFuture;

public class MainActivity extends AppCompatActivity {
    FragmentManager fragmentManager = getSupportFragmentManager();
    NetServerController netServerController;
    boolean isBound = false;



    /// Перенести эту гадость в воркер
    private Handler handler = new Handler();
    private static final long DELAY_MINUTES = 1 * 60 * 1000; // 1 минута в миллисекундах
    private Runnable periodicTask = new Runnable() {
        @Override
        public void run() {
            GetMessages();
            handler.postDelayed(this, DELAY_MINUTES);
        }
    };
    @Override
    protected void onResume() {
        super.onResume();
        handler.postDelayed(periodicTask, DELAY_MINUTES); // Запуск первой задачи при возобновлении активности
    }
    @Override
    protected void onPause() {
        super.onPause();
        handler.removeCallbacks(periodicTask); // Остановка задачи при приостановке активности
        JsonDataSaver.SaveChats(SharedViewByChats.getChatList(), this);
    }
    @Override
    protected void onDestroy() {
        super.onDestroy();
        handler.removeCallbacks(periodicTask); // Остановка задачи при приостановке активности
        JsonDataSaver.SaveChats(SharedViewByChats.getChatList(), this);
    }
    ///






    private ServiceConnection connection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName className, IBinder service) {
            Log.i("WebSocket", "Session is starting");
            NetServerController.LocalBinder binder = (NetServerController.LocalBinder) service;
            netServerController = binder.getService();
            isBound = true;

            OnCreateNet();
        }

        @Override
        public void onServiceDisconnected(ComponentName arg0) {
            Log.i("WebSocket", "Session is closed");
            isBound = false;
        }
    };

    @Override
    public void onBackPressed() {
        FragmentManager fragmentManager = getSupportFragmentManager();
        Fragment currentFragment = fragmentManager.findFragmentById(R.id.main_fragment);

        if (currentFragment instanceof SingleChatFragment) {
            OpenChatsFragment();
        } else if (currentFragment instanceof SettingsFragment) {
            OpenChatsFragment();
        } else if (currentFragment instanceof AddChatFragment) {
            OpenChatsFragment();
        } else if (currentFragment instanceof CreateChatFragment) {
            OpenChatsFragment();
        } else {
            super.onBackPressed();
        }
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        //Создание Json
        JsonDataSaver.AwakeJson();



        // Реализация создания сервера
        Log.i("WebSocket", "Try bindService");
        Intent intent = new Intent(this, NetServerController.class);
        startService(intent);
        bindService(intent, connection, Context.BIND_AUTO_CREATE);

    }

    protected void OnCreateNet(){
        //netServerController.CreateNewChat("", false);
        //Все для чего нужен сервер
        OpenChatsFragment();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.upper_menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        if (id == R.id.action_setting_profile) {
            Toast.makeText(MainActivity.this, "Профиль", Toast.LENGTH_LONG).show();
            return true;
        } else if (id == R.id.action_setting_theme) {
            Toast.makeText(MainActivity.this, "Тема", Toast.LENGTH_LONG).show();
            OpenSettingsFragment();
            return true;
        } else if (id == R.id.action_setting_chats) {
            Toast.makeText(MainActivity.this, "Чаты", Toast.LENGTH_LONG).show();
            OpenChatsFragment();
            return true;
        } else if (id == R.id.action_setting_add_chat) {
            Toast.makeText(MainActivity.this, "Добавить чат", Toast.LENGTH_LONG).show();
            OpenAddChatFragment();
            return true;
        } else if (id == R.id.action_setting_create_chat) {
            Toast.makeText(MainActivity.this, "Создать чат", Toast.LENGTH_LONG).show();
            OpenCreateChatFragment();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }














    private void OpenChatsFragment(){
        SharedViewByChats.setListener(null);

        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        ChatsFragment chatFragment = new ChatsFragment();

        GetMessages();

        fragmentTransaction.replace(R.id.main_fragment, chatFragment);
        fragmentTransaction.commit();
    }

    public void OpenSettingsFragment(){
        SharedViewByChats.setListener(null);

        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        SettingsFragment settingsFragment = new SettingsFragment();


        fragmentTransaction.replace(R.id.main_fragment, settingsFragment);
        fragmentTransaction.commit();
    }

    public void OpenChat(Chat chat){
        SharedViewByChats.setListener(null);

        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        SingleChatFragment singleChatFragment = new SingleChatFragment();

        GetMessages();
        SharedViewByChats.setSelectChat(chat);

        fragmentTransaction.replace(R.id.main_fragment, singleChatFragment);
        fragmentTransaction.commit();
    }

    public void OpenAddChatFragment(){
        SharedViewByChats.setListener(null);

        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        AddChatFragment addChatFragment = new AddChatFragment();


        fragmentTransaction.replace(R.id.main_fragment, addChatFragment);
        fragmentTransaction.commit();
    }

    public void OpenCreateChatFragment(){
        SharedViewByChats.setListener(null);

        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        CreateChatFragment createChatFragment = new CreateChatFragment();


        fragmentTransaction.replace(R.id.main_fragment, createChatFragment);
        fragmentTransaction.commit();
    }









    public void CreateChat(View view) {
        String chatPassword = String.valueOf(((EditText) findViewById(R.id.create_chat_password)).getText());
        ToggleButton toggleButton = (ToggleButton) findViewById(R.id.create_chat_is_privacy);

        CompletableFuture<String> future = netServerController.CreateNewChat(chatPassword, toggleButton.isChecked());
        future.thenAccept(goin -> {
            if (goin != null) {
                try {
                    AddChat(goin, chatPassword);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
                Log.i("WebSocket", goin);
            } else {
                Log.e("WebSocket", "Get send msg unsuccessful");
            }
        });
    }

    public void AddChat(View view) throws Exception {
        String chatId = String.valueOf(((EditText) findViewById(R.id.add_chat_login)).getText());
        String chatPassword = String.valueOf(((EditText) findViewById(R.id.add_chat_password)).getText());

        User user = new User(true);
        byte[] pk = Crypt.CriptPublicKey(chatId, chatPassword, user.GetPublicKey());

        CompletableFuture<String> future = NetServerController.AddUserToChat(pk, chatId, chatPassword);
        future.thenAccept(goin -> {
            if (goin != null) {
                LocalAddChat(chatId, chatPassword, user, Integer.valueOf(goin));
                Log.i("WebSocket", goin);
            } else {
                Log.e("WebSocket", "Get send msg unsuccessful");
            }
        });
    }

    public void AddChat(String chatId, String chatPassword) throws Exception {

        User user = new User(true);
        byte[] pk = Crypt.CriptPublicKey(chatId, chatPassword, user.GetPublicKey());

        CompletableFuture<String> future = NetServerController.AddUserToChat(pk, chatId, chatPassword);
        future.thenAccept(goin -> {
            if (goin != null) {
                LocalAddChat(chatId, goin, user, Integer.valueOf(goin));
                Log.i("WebSocket", goin);
            } else {
                Log.e("WebSocket", "Get send msg unsuccessful");
            }
        });
    }

    private void LocalAddChat(String idChat, String chatPassword, User user, Integer idUser){
        ArrayList<Chat> chatList = SharedViewByChats.getChatList();
        if (chatList == null){
            chatList = new ArrayList<>();
        }

        HashMap<Integer, User> users = new HashMap<>();
        users.put(idUser, user);
        chatList.add(new Chat(idUser, new ArrayList<>(), users, idChat, chatPassword));

        SharedViewByChats.setChatList(chatList);
    }

    public void SendMessage(View view) {
        EditText editText = ((EditText) findViewById(R.id.message_edit_text));
        byte[] messange = SharedViewByChats.getSelectChat().GetUser(
                SharedViewByChats.getSelectChat().GetYourId()).Encrypt(String.valueOf(editText.getText()));
        Timestamp ts = new Timestamp(System.currentTimeMillis());

        CompletableFuture<String> future = NetServerController.SendMessage(messange, SharedViewByChats.getSelectChat().GetYourId(), ts);
        future.thenAccept(goin -> {
            if (goin != null) {
                editText.setText("");

                if(goin.equals("true")){
                    GetMessages();
                }

                Log.i("WebSocket", goin);
            } else {
                Log.e("WebSocket", "Get send msg unsuccessful");
            }
        });
    }










    private void CheckSavedChats(){
        if (SharedViewByChats.getChatList() == null){
            Log.i("Chats", "Start Check Save");
            ArrayList<Chat> chats = (JsonDataSaver.TryLoadChats(this));
            Log.i("Chats", "End Check Save");
            if(chats == null){
                chats = new ArrayList<>();
                // Это комментировать
                CreateFictChats(chats);
                JsonDataSaver.SaveChats(chats, this);
            }
            Log.i("Chats", "Start sharedViewByChats");
            SharedViewByChats.setChatList(chats);
            Log.i("Chats", "End sharedViewByChats");
        }
    }

    private String CreateGetMessagesStr(){
        StringBuilder str = new StringBuilder();

        str.append(SharedViewByChats.getChatList().size());

        for (int i = 0; i < SharedViewByChats.getChatList().size(); i++){
            Chat chat = SharedViewByChats.getChatList().get(i);
            HashMap<Integer, ArrayList<Integer>> missMsg = chat.GetMissingIdsForAllAuthors();
            if(missMsg == null || missMsg.isEmpty()){
                continue;
            }

            str.append(" " + chat.GetChatId() + " " + missMsg.size());

            for(Map.Entry<Integer, ArrayList<Integer>> entry : missMsg.entrySet()){
                int authorId = entry.getKey();
                ArrayList<Integer> messages = entry.getValue();
                int messageCount = messages.size();

                str.append(" " + authorId + " " + messageCount);

                for(Integer msg : messages){
                    str.append(" " + msg);
                }
            }
        }

        return str.toString();
    }

    private void GetMessages(){
        CheckSavedChats();

        String str = CreateGetMessagesStr();

        CompletableFuture<String[]> future = NetServerController.GetMessages(str.toString());
        future.thenAccept(goin -> {
            if (goin != null) {
                UpdateMessages(goin);
                Log.i("WebSocket", String.valueOf(goin.length));
            } else {
                Log.e("WebSocket", "Get send msg unsuccessful");
            }
        });
    }

    public void UpdateMessages(String[] parts){
        Log.i("Chats", "Start Chat Upgrade");
        ArrayList<Chat> chatList = new ArrayList<>();
        chatList.addAll(SharedViewByChats.getChatList());
        int index = 0;

        int chatCount = Integer.valueOf(parts[index++]);
        for(int i = 0; i < chatCount; i++){
            String chatId = parts[index++];
            int authorCount = Integer.valueOf(parts[index++]);

            for(int j = 0; j < authorCount; j++) {
                int authorId = Integer.parseInt(parts[index++]);
                int msgCount = Integer.valueOf(parts[index++]);

                for(int k = 0; k < msgCount; k++) {

                    int idMsg = Integer.parseInt(parts[index++]);

                    String timeMillis1 = parts[index++];
                    String timeMillis2 = parts[index++];
                    String timeString = timeMillis1 + " " + timeMillis2;
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm:ss");
                    LocalDateTime time = LocalDateTime.parse(timeString, formatter);

                    byte[] msg = Base64.getDecoder().decode(parts[index++]);

                    for (Chat chat : chatList) {
                        if (Objects.equals(chat.GetChatId(), chatId)) {
                            Messange message = new Messange(authorId, idMsg, msg, time);
                            if (chat.GetUser(authorId) == null) {
                                chat.AddUser(authorId, new User(false));
                            }
                            chat.AddChangeMessage(message);
                            break;
                        }
                    }
                }
            }
        }
        JsonDataSaver.SaveChats(chatList, this);


        Log.i("Chats", "Start Chat Upd");
        SharedViewByChats.setChatList(chatList);
        Log.i("Chats", "End Chat Upd");
    }
}