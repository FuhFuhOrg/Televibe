package com.example.teletypesha.netCode;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;

import java.io.Serializable;
import java.net.URI;
import java.net.URISyntaxException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.CompletableFuture;

import tech.gusavila92.websocketclient.WebSocketClient;

public class NetServerController extends Service implements Serializable {
    private static int k = 0;
    public static String s = "95.165.27.159";

    public static WebSocketClient webSocketClient;
    private static Map<Integer, OnMessageReceived> listeners = new HashMap<>();

    public void AddNewChat(String chatId, String chatPassword) {
    }

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

    public static void setOnMessageReceivedListener(int id, OnMessageReceived listener) {
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

    private static void SendRequest(int id, String requestWord, String string){
        if(webSocketClient != null)
            webSocketClient.send("/sql " + requestWord + " " + String.valueOf(id) + " " + string);
    }

    private static void SendUnregistredRequest(String string){
        webSocketClient.send(string);
    }

    private static int GetK(){
        k++;
        if(k >= 1000000){
            k = 0;
        }
        return k;
    }

    // -------------------------------------------------------------------------------------------

    // Запросы к серверу

    // -------------------------------------------------------------------------------------------

    // Создание нового чата
    public static CompletableFuture<String> CreateNewChat(String chatPassword, boolean isPrivacy) {
        CompletableFuture<String> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId , new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) {
                if (parts.length > 0) {
                    future.complete(parts[0]);
                }
            }
        });

        Log.i("WebSocket", "CreateNewChat");
        SendRequest(requestId, "ChatCreate", isPrivacy + " " + String.valueOf(chatPassword));

        return future;
    }

    public static CompletableFuture<String> AddUserToChat(String publicKey, String idChat, String chatPassword) {
        CompletableFuture<String> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId , new OnMessageReceived() {
            public void onMessage(String[] parts) {
                if (parts.length > 0) {
                    future.complete(parts[0]);
                } else {
                    future.complete(null);
                }
            }
        });

        Log.i("WebSocket", "addUserToChat");
        SendRequest(requestId, "addUserToChat", publicKey + " " + idChat + " " + chatPassword);

        return future;
    }

    // Отправить сообщение
    public static CompletableFuture<String> SendMessage(byte[] msg, int idSender, Timestamp timeMsg) {
        CompletableFuture<String> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId , new OnMessageReceived() {
            public void onMessage(String[] parts) {
                if (parts.length > 0) {
                    future.complete(parts[0]);
                } else {
                    future.complete(null);
                }
            }
        });

        Log.i("WebSocket", "SendMessage");
        String timeWithoutMilliseconds = (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format(timeMsg);
        SendRequest(requestId, "SendMessage", String.valueOf(idSender) + " " + String.valueOf(timeWithoutMilliseconds) + " " + Base64.getEncoder().encodeToString(msg));

        return future;
    }

    // Вернуть сообщения, которые больше idMsg
    public static CompletableFuture<String[]> GetMessages(String str) {
        CompletableFuture<String[]> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) {
                if (parts.length > 0) {
                    if (parts.length > 1) {
                        future.complete(parts);
                    } else {
                        future.complete(null);
                    }
                }
            }
        });

        Log.i("WebSocket", "GetMessages");
        SendRequest(requestId, "GetMessages", str);

        return future;
    }

    // Удаление сообщения
    public static CompletableFuture<String> DeleteMessage(int idSender, int idMsg) {
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
    public static CompletableFuture<String> RefactorMessage(int idMsg, int idSender, byte[] msg) {
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

        Log.i("WebSocket", "RefactorMessage");
        SendRequest(requestId, "RefactorMessage", String.valueOf(idMsg) + " " + String.valueOf(idSender) + " " + Base64.getEncoder().encodeToString(msg));

        return future;
    }
}
