package com.example.teletypesha.adapters;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupMenu;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.RecyclerView;

import com.example.teletypesha.R;
import com.example.teletypesha.activitys.MainActivity;
import com.example.teletypesha.fragments.SingleChatFragment;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.Message;

import java.util.Objects;

public class ChatAdapter extends RecyclerView.Adapter<ChatAdapter.ChatViewHolder> {

    private Chat chat;
    private int width;
    private MainActivity mainActivity;
    private SingleChatFragment singleChatFragment;

    public ChatAdapter(Chat chat, int width, MainActivity mainActivity, SingleChatFragment singleChatFragment) {
        this.chat = chat;
        this.width = width;
        this.mainActivity = mainActivity;
        this.singleChatFragment = singleChatFragment;
        Log.i("Debug Adp", "Adapter Create");
        Log.i("Debug Adp", String.valueOf(chat.GetMessanges().size()));
    }

    @NonNull
    @Override
    public ChatAdapter.ChatViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        Log.i("Debug Adp", "S Create onCreateViewHolder");
        View itemView = LayoutInflater.from(parent.getContext()).inflate(R.layout.messange_layout, parent, false);
        Log.i("Debug Adp", "E Create onCreateViewHolder");
        return new ChatAdapter.ChatViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(@NonNull ChatAdapter.ChatViewHolder holder, int position) {
        Message message = chat.GetMessanges().get(position);
        holder.bind(message);

        if (!message.GetIsReaded()) {
            message.SetIsReaded(true); // Помечаем сообщение как прочитанное
        }
    }

    @Override
    public int getItemCount() {
        return chat.GetMessanges().size();
    }

    public class ChatViewHolder extends RecyclerView.ViewHolder {

        private CardView buttonLayoutView;
        private TextView msgAuthor, messangeText;

        public ChatViewHolder(@NonNull View itemView) {
            super(itemView);
            buttonLayoutView = itemView.findViewById(R.id.in_messange_layout);
            msgAuthor = itemView.findViewById(R.id.msg_author);
            messangeText = itemView.findViewById(R.id.msg_text);

            // Добавляем обработчик нажатия для отображения меню
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    // Создаем PopupMenu
                    PopupMenu popupMenu = new PopupMenu(mainActivity, view);
                    // Наполняем PopupMenu элементами из ресурсов
                    popupMenu.inflate(R.menu.menu_message_options);

                    // Устанавливаем обработчик кликов на элементы PopupMenu
                    popupMenu.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                        @Override
                        public boolean onMenuItemClick(MenuItem item) {
                            int position = getAdapterPosition();
                            if (position != RecyclerView.NO_POSITION) {
                                int itemId = item.getItemId();
                                if (itemId == R.id.edit_option) {
                                    // Обработка нажатия на кнопку "Редактировать"
                                    singleChatFragment.StartEditMessage(chat, chat.GetMessanges().get(position));
                                    return true;
                                } else if (itemId == R.id.delete_option) {
                                    // Обработка нажатия на кнопку "Удалить"
                                    mainActivity.DeleteMessage(chat, chat.GetMessanges().get(position));
                                    return true;
                                }
                            }
                            return false;
                        }
                    });

                    // Показываем PopupMenu
                    popupMenu.show();
                }
            });
        }

        public void bind(Message messange) {
            // Устанавливаем данные в элементы макета
            Log.i("Debug Adp", "S Create Maket");
            msgAuthor.setText(chat.GetUser(messange.author).GetName());
            messangeText.setText(chat.GetUser(messange.author).Decrypt(messange.text));

            ConstraintLayout.LayoutParams layoutParams = (ConstraintLayout.LayoutParams) buttonLayoutView.getLayoutParams();
            if (Objects.equals(chat.GetYourId(), messange.author)) {
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
