package com.example.teletypesha.adapters;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.teletypesha.activitys.MainActivity;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.R;
import com.example.teletypesha.itemClass.Message;

import java.util.List;

public class ChatListAdapter extends RecyclerView.Adapter<ChatListAdapter.ChatViewHolder> {

    private List<Chat> chatList;
    private int width;
    private MainActivity mainActivity;

    // Конструктор адаптера для списка чатов, принимает список чатов, ширину экрана и активность
    public ChatListAdapter(List<Chat> chatList, int width, MainActivity mainActivity) {
        this.chatList = chatList;
        this.width = width;
        this.mainActivity = mainActivity;
        Log.i("Debug Adp", "Adapter Create");
        Log.i("Debug Adp", String.valueOf(chatList.size()));
    }

    // Создает ViewHolder для элемента списка чатов
    @NonNull
    @Override
    public ChatViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        Log.i("Debug Adp", "S Create onCreateViewHolder");
        View itemView = LayoutInflater.from(parent.getContext()).inflate(R.layout.chat_button, parent, false);
        Log.i("Debug Adp", "E Create onCreateViewHolder");
        return new ChatViewHolder(itemView);
    }

    // Привязывает данные чата к ViewHolder
    @Override
    public void onBindViewHolder(@NonNull ChatViewHolder holder, int position) {
        holder.bind(chatList.get(position));
    }

    // Возвращает количество чатов в списке
    @Override
    public int getItemCount() {
        return chatList.size();
    }

    // ViewHolder для представления элемента чата в списке
    public class ChatViewHolder extends RecyclerView.ViewHolder {

        private LinearLayout buttonLayoutView;
        private TextView labelView, lastMsgView;

        // Инициализация ViewHolder и его элементов
        public ChatViewHolder(@NonNull View itemView) {
            super(itemView);
            buttonLayoutView = itemView.findViewById(R.id.chat_button);
            labelView = itemView.findViewById(R.id.chat_label);
            lastMsgView = itemView.findViewById(R.id.chat_last_msg);
        }

        // Привязывает данные чата к элементам макета
        public void bind(Chat chat) {
            // Устанавливаем данные в элементы макета
            Log.i("Debug Adp", "S Create Maket");
            labelView.setText(chat.GetLabel());
            Message msg = chat.getLastMsg();
            if (msg != null) {
                lastMsgView.setText(chat.GetUser(msg.author).Decrypt(msg.text));
            }

            // Устанавливаем обработчик нажатия для открытия чата
            buttonLayoutView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    mainActivity.OpenChat(chat);
                }
            });

            // Устанавливаем ширину элемента
            buttonLayoutView.getLayoutParams().width = (int) (width * 1);
            Log.i("Debug Adp", "E Create Maket");
        }
    }
}
