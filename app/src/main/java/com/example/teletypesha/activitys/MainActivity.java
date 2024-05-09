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

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.example.teletypesha.R;
import com.example.teletypesha.fragments.ChatsFragment;
import com.example.teletypesha.fragments.SettingsFragment;
import com.example.teletypesha.fragments.SingleChatFragment;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.jsons.JsonDataSaver;
import com.example.teletypesha.netCode.NetServerController;

public class MainActivity extends AppCompatActivity {
    FragmentManager fragmentManager = getSupportFragmentManager();
    Chat settedChat;

    NetServerController netServerController;
    boolean isBound = false;

    JsonDataSaver jsonDataSaver = new JsonDataSaver();

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

    public void SendMessage(View view){
        String messange = String.valueOf(((EditText) findViewById(R.id.message_edit_text)).getText());
        FictiveSendMessange(messange, settedChat, settedChat.GetYourId());
    }

    public void FictiveSendMessange(String messange, Chat chat, Integer senderId){
        // Код
    }

}