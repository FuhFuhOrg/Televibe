package com.example.teletypesha.activitys;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
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

import com.example.teletypesha.R;
import com.example.teletypesha.fragments.AddChatFragment;
import com.example.teletypesha.fragments.ChatsFragment;
import com.example.teletypesha.fragments.CreateChatFragment;
import com.example.teletypesha.fragments.SettingsFragment;
import com.example.teletypesha.fragments.SingleChatFragment;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.jsons.JsonDataSaver;
import com.example.teletypesha.netCode.NetServerController;

import java.sql.Timestamp;
import java.util.concurrent.CompletableFuture;

public class MainActivity extends AppCompatActivity {
    FragmentManager fragmentManager = getSupportFragmentManager();
    Chat settedChat;

    NetServerController netServerController;
    boolean isBound = false;

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



        //Все для чего нужен сервер
        OpenChatsFragment();
    }

    protected void OnCreateNet(){
        netServerController.CreateNewChat("", false);
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
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        ChatsFragment chatFragment = new ChatsFragment();
        fragmentTransaction.replace(R.id.main_fragment, chatFragment);
        fragmentTransaction.commit();
    }

    public void OpenSettingsFragment(){
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        SettingsFragment settingsFragment = new SettingsFragment();
        fragmentTransaction.replace(R.id.main_fragment, settingsFragment);
        fragmentTransaction.commit();
    }

    public void OpenChat(Chat chat){
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        SingleChatFragment singleChatFragment = new SingleChatFragment();
        singleChatFragment.SetChat(chat);
        settedChat = chat;
        fragmentTransaction.replace(R.id.main_fragment, singleChatFragment);
        fragmentTransaction.commit();
    }

    public void OpenAddChatFragment(){
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        AddChatFragment addChatFragment = new AddChatFragment();
        fragmentTransaction.replace(R.id.main_fragment, addChatFragment);
        fragmentTransaction.commit();
    }

    public void OpenCreateChatFragment(){
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        CreateChatFragment createChatFragment = new CreateChatFragment();
        fragmentTransaction.replace(R.id.main_fragment, createChatFragment);
        fragmentTransaction.commit();
    }

    public void CreateChat(View view) {
        String chatPassword = String.valueOf(((EditText) findViewById(R.id.create_chat_password)).getText());
        ToggleButton toggleButton = (ToggleButton) findViewById(R.id.create_chat_is_privacy);

        netServerController.CreateNewChat(chatPassword, toggleButton.isChecked());
    }

    public void AddChat(View view) {
        String chatId = String.valueOf(((EditText) findViewById(R.id.add_chat_login)).getText());
        String chatPassword = String.valueOf(((EditText) findViewById(R.id.add_chat_password)).getText());

        //netServerController.AddNewChat(chatId, chatPassword);
    }

    public void SendMessage(View view) {
        byte[] messange = settedChat.GetUser(settedChat.GetYourId()).Encrypt(String.valueOf(((EditText) findViewById(R.id.message_edit_text)).getText()));
        Timestamp ts = new Timestamp(System.currentTimeMillis());

        CompletableFuture<String> future = netServerController.SendMessage(messange, settedChat.GetYourId(), ts);
        future.thenAccept(goin -> {
            if (goin != "-" && goin != null) {
                Log.i("WebSocket", goin);
            } else {
                Log.e("WebSocket", "Get send msg unsuccessful");
            }
        });
    }
}