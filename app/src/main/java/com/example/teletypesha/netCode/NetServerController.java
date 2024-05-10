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
import java.sql.Timestamp;
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

    // -------------------------------------------------------------------------------------------

    // Создание нового чата
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

        Log.i("WebSocket", "CreateNewChat");
        SendRequest(requestId, "ChatCreate", chatPassword + " " + isPrivacy);

        return future;
    }

    // Отправить сообщение
    public CompletableFuture<String> SendMessage(int idMsg, int idSender, Timestamp timeMsg, String msg, PublicKey publicKey) throws Exception {
        CompletableFuture<String> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId , new OnMessageReceived() {
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
        SendRequest(requestId, "SendMessage", String.valueOf(requestId) + " " + String.valueOf(idMsg) + " " + String.valueOf(idSender) + " " + String.valueOf(timeMsg));

        return future;
    }

    // Вернуть сообщения, которые больше idMsg
    public CompletableFuture<String> GetMessages(int idSender, int idMsg) throws Exception {
        CompletableFuture<String> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) {
                if (parts.length > 0) {
                    if (parts.length > 1) {
                        future.complete(parts[1]);
                    } else {
                        future.complete(null);
                    }
                }
            }
        });

        Log.i("WebSocket", "GetMessages");
        SendRequest(requestId, "GetMessages", String.valueOf(idSender) + " " + String.valueOf(idMsg));

        return future;
    }

    // Удаление сообщения
    public CompletableFuture<String> DeleteMessage(int idSender, int idMsg) throws Exception {
        CompletableFuture<String> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
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

        Log.i("WebSocket", "DeleteMessage");
        SendRequest(requestId, "DeleteMessage", String.valueOf(idSender) + " " + String.valueOf(idMsg));

        return future;
    }

    // Изменение сообщения
    public CompletableFuture<String> RefactorMessage(int idMsg, String msg, PublicKey publicKey) throws Exception {
        CompletableFuture<String> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
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

        Log.i("WebSocket", "RefactorMessage");
        SendRequest(requestId, "RefactorMessage", String.valueOf(idMsg));

        return future;
    }

    // Поиск сообщения по ключу в msg
    public CompletableFuture<String> ReturnMessageByKeyWord(int idSender, String msg, PublicKey publicKey) throws Exception {
        CompletableFuture<String> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
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

        Log.i("WebSocket", "ReturnMessageByKeyWord");
        SendRequest(requestId, "ReturnMessageByKeyWord", String.valueOf(idSender));

        return future;
    }

    // Возврат сообщения по idMsg
    public CompletableFuture<String> ReturnMessageByIdMsg(int idMsg) throws Exception {
        CompletableFuture<String> future = new CompletableFuture<>();
        int requestId = GetK();
        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
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

        Log.i("WebSocket", "ReturnMessageByIdMsg");
        SendRequest(requestId, "ReturnMessageByIdMsg", String.valueOf(idMsg));

        return future;
    }

    // Возврат k сообщений, отсортированных по времени
    public CompletableFuture<String> ReturnLastKMessages(int idSender, int kMessages) throws Exception {
        CompletableFuture<String> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
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

        Log.i("WebSocket", "ReturnLastKMessages");
        SendRequest(requestId, "ReturnLastKMessages", String.valueOf(idSender) + " " + String.valueOf(kMessages));

        return future;
    }

}
