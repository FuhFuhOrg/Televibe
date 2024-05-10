package com.example.teletypesha.netCode;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import android.util.Log;
import android.util.Pair;

import androidx.annotation.Nullable;

import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.Messange;

import java.io.Serializable;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.CompletableFuture;
import java.security.*;
import javax.crypto.*;

import tech.gusavila92.websocketclient.WebSocketClient;

import com.example.teletypesha.crypt.Crypt;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.Messange;

public class NetServerController extends Service implements Serializable {
    private int k = 0;
    public static String s = "95.165.27.159";

    public static WebSocketClient webSocketClient;
    private Map<Integer, OnMessageReceived> listeners = new HashMap<>();

    public interface OnMessageReceived {
        void onMessage(String[] parts) throws Exception;
    }

    // Binder, предоставленный клиентам
    private final IBinder binder = new LocalBinder();

    // Класс, используемый для клиентского интерфейса Binder
    public class LocalBinder extends Binder {
        public NetServerController getService() {
            // Возвращаем экземпляр NetServerController,
            // чтобы клиенты могли вызывать публичные методы
            return NetServerController.this;
        }
    }

    public void setOnMessageReceivedListener(int id, OnMessageReceived listener) {
        listeners.put(id, listener);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        createWebSocketClient();
        return START_STICKY; // Сервис будет перезапущен, если система его уничтожит
    }

    public void createWebSocketClient() {
        Log.i("WebSocket", "Try createWebSocketClient");
        URI uri;
        try {
            // Connect to local host
            uri = new URI("ws://"+s+":17825/");
        }
        catch (URISyntaxException e) {
            e.printStackTrace();
            return;
        }

        webSocketClient = new WebSocketClient(uri) {
            @Override
            public void onOpen() {
                Log.i("WebSocket", "Session is starting");
                SendUnregistredRequest("Hello World!");
            }

            @Override
            public void onTextReceived(String s) {
                Log.i("WebSocket", "Message received");
                // Обработка полученного сообщения
                String[] parts = s.split(" ");
                try {
                    int id = Integer.parseInt(parts[0]);
                    OnMessageReceived listener = listeners.get(id);
                    if (listener != null) {
                        listener.onMessage(Arrays.copyOfRange(parts, 1, parts.length));
                        listeners.remove(id);
                    }

                }
                catch (Exception e){
                    Log.i("WebSocket", s);
                }
            }

            @Override
            public void onBinaryReceived(byte[] data) {
            }

            @Override
            public void onPingReceived(byte[] data) {
            }

            @Override
            public void onPongReceived(byte[] data) {
            }

            @Override
            public void onException(Exception e) {
                Log.e("WebSocket", Objects.requireNonNull(e.getMessage()));
            }

            @Override
            public void onCloseReceived() {
                Log.i("WebSocket", "Closed ");
            }
        };

        webSocketClient.setConnectTimeout(10000);
        webSocketClient.setReadTimeout(60000);
        webSocketClient.enableAutomaticReconnection(5000);
        webSocketClient.connect();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return binder;
    }

    private void SendRequest(int id, String requestWord, String string){
        webSocketClient.send("/sql " + requestWord + " " + String.valueOf(id) + " " + string);
    }

    private void SendUnregistredRequest(String string){
        webSocketClient.send(string);
    }

    private int GetK(){
        k++;
        if(k >= 1000000){
            k = 0;
        }
        return k;
    }

    public CompletableFuture<String> CreateNewChat(String chatPassword, boolean isPrivacy) {
        CompletableFuture<String> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId , new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) {
                if (parts.length > 0 && parts[0].equals(String.valueOf(requestId))) {
                    if (parts.length > 1) {
                        future.complete(parts[1]);
                    } else {
                        future.complete(null);
                    }
                }
            }
        });

        Log.i("WebSocket", "SendMessage");
        SendRequest(requestId, "ChatCreate", chatPassword + " " + isPrivacy);

        return future;
    }


    public CompletableFuture<String> FictiveSendMessange(byte[] messange, Chat chat, Integer senderId){
        CompletableFuture<String> future = new CompletableFuture<>();
        // Код









        return future;
    }

    public CompletableFuture<String> FictiveAddChat(String chatId, String password){
        CompletableFuture<String> future = new CompletableFuture<>();
        // Код









        return future;
    }
}
