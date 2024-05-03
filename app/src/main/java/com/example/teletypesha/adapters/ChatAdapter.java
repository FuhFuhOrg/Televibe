package com.example.teletypesha.adapters;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.R;

import java.util.List;

public class ChatAdapter extends RecyclerView.Adapter<ChatAdapter.ChatViewHolder> {

    private List<Chat> chatList;
    private int width;

    public ChatAdapter(List<Chat> chatList, int width) {
        this.chatList = chatList;
        this.width = width;
        Log.i("Debug Adp", "Adapter Create");
        Log.i("Debug Adp", String.valueOf(chatList.size()));
    }

    @NonNull
    @Override
    public ChatViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        Log.i("Debug Adp", "S Create onCreateViewHolder");
        View itemView = LayoutInflater.from(
                parent.getContext()).inflate(R.layout.chat_button,
                parent, false);
        Log.i("Debug Adp", "E Create onCreateViewHolder");
        return new ChatViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull ChatViewHolder holder, int position) {
        holder.bind(chatList.get(position));
    }

    @Override
    public int getItemCount() {
        return chatList.size();
    }

    public class ChatViewHolder extends RecyclerView.ViewHolder {

        private LinearLayout buttonLayoutView;
        private TextView textView;

        public ChatViewHolder(@NonNull View itemView) {
            super(itemView);
            buttonLayoutView = itemView.findViewById(R.id.chat_button);
            textView = itemView.findViewById(R.id.chat_label);
        }

        public void bind(Chat item) {
            // Устанавливаем данные в элементы макета
            Log.i("Debug Adp", "S Create Maket");
            textView.setText(item.getName());


            buttonLayoutView.getLayoutParams().width = (int) (width * 1);
            Log.i("Debug Adp", "E Create Maket");
            // Предполагая, что у вас есть изображения для каждого элемента, вы можете установить их здесь
            // imageView.setImageResource(R.drawable.your_image_resource);
        }
    }
}