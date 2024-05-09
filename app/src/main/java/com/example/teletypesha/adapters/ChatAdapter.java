package com.example.teletypesha.adapters;

import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.teletypesha.R;
import com.example.teletypesha.activitys.MainActivity;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.Messange;

import java.util.Objects;

public class ChatAdapter extends RecyclerView.Adapter<ChatAdapter.ChatViewHolder> {

    private Chat chat;
    private int width;
    private MainActivity mainActivity;

    public ChatAdapter(Chat chat, int width, MainActivity mainActivity) {
        this.chat = chat;
        this.width = width;
        this.mainActivity = mainActivity;
        Log.i("Debug Adp", "Adapter Create");
        Log.i("Debug Adp", String.valueOf(chat.GetMessanges().size()));
    }

    @NonNull
    @Override
    public ChatAdapter.ChatViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        Log.i("Debug Adp", "S Create onCreateViewHolder");
        View itemView = LayoutInflater.from(
                parent.getContext()).inflate(R.layout.messange_layout,
                parent, false);
        Log.i("Debug Adp", "E Create onCreateViewHolder");
        return new ChatAdapter.ChatViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull ChatAdapter.ChatViewHolder holder, int position) {
        holder.bind(chat.GetMessanges().get(position));
    }

    @Override
    public int getItemCount() {
        return chat.GetMessanges().size();
    }

    public class ChatViewHolder extends RecyclerView.ViewHolder {

        private LinearLayout buttonLayoutView;
        private TextView msgAuthor, messangeText;

        public ChatViewHolder(@NonNull View itemView) {
            super(itemView);
            buttonLayoutView = itemView.findViewById(R.id.in_messange_layout);
            msgAuthor = itemView.findViewById(R.id.msg_author);
            messangeText = itemView.findViewById(R.id.msg_text);
        }

        public void bind(Messange messange) {
            // Устанавливаем данные в элементы макета
            Log.i("Debug Adp", "S Create Maket");
            msgAuthor.setText(chat.GetUser(messange.author).GetName());
            messangeText.setText(messange.text);

            ConstraintLayout.LayoutParams layoutParams = (ConstraintLayout.LayoutParams) buttonLayoutView.getLayoutParams();
            if (Objects.equals(chat.GetYourId(), messange.author)){
                layoutParams.endToEnd = ConstraintLayout.LayoutParams.PARENT_ID;
                layoutParams.startToStart = ConstraintLayout.LayoutParams.UNSET;
                layoutParams.setMarginEnd(2);
            } else {
                layoutParams.startToStart = ConstraintLayout.LayoutParams.PARENT_ID;
                layoutParams.endToEnd = ConstraintLayout.LayoutParams.UNSET;
                layoutParams.setMarginStart(2);
            }
            buttonLayoutView.setLayoutParams(layoutParams);


            buttonLayoutView.getLayoutParams().width = (int) (width * 0.6);
            Log.i("Debug Adp", "E Create Maket");
        }
    }
}