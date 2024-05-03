package com.example.teletypesha.activitys;

import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.teletypesha.R;
import com.example.teletypesha.adapters.ChatAdapter;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.Messange;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Random;

public class MainActivity extends AppCompatActivity {

    ArrayList<Chat> chatList = new ArrayList<>();
    ChatAdapter adapter;

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



        Log.i("Debug", "Started");

        GetFictChats();

        CreateItemList();

        Log.i("Debug", "Start Ok");
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
        getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
        adapter = new ChatAdapter(chatList, displayMetrics.widthPixels);

        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                RecyclerView recyclerView = findViewById(R.id.recycler);
                recyclerView.setLayoutManager(new LinearLayoutManager(MainActivity.this)); // Добавлено
                Log.i("Debug", recyclerView.toString());
                recyclerView.setAdapter(adapter);
                Log.i("Debug", "adapter set");
            }
        });
    }
}