package com.example.trpp_main_project.NetCode;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;

import com.example.trpp_main_project.ItemControl.ReceptsItem;

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

public class NetServerController extends Service implements Serializable {
    private int k = 0;
    public static String s = "95.165.27.159";

    private PublicKey publicKey;
    private PrivateKey privateKey;

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

    private void PublicPrivateKeyGeneration(String msg) throws Exception {
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
        keyPairGenerator.initialize(2048);
        KeyPair keyPair = keyPairGenerator.generateKeyPair();
        publicKey = keyPair.getPublic();
        privateKey = keyPair.getPrivate();
    }

    private byte[] Encryption(String msg) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);

        return cipher.doFinal(msg.getBytes());
    }

    public String decrypt(String encryptedMsg) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] decodedMsg = Base64.getDecoder().decode(encryptedMsg);
        byte[] decryptedMsg = cipher.doFinal(decodedMsg);
        return new String(decryptedMsg);
    }

    public String getPublicKey() {
        return Base64.getEncoder().encodeToString(publicKey.getEncoded());
    }

    public String gertPrivateKey() {
        return Base64.getEncoder().encodeToString(privateKey.getEncoded());
    }








//--------------------------------------------------------------------------------------------------








    public CompletableFuture<String> GetId() {
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
        SendRequest(requestId, "GenerateUniqueUserId", "");

        return future;
    }

    public CompletableFuture<ArrayList<ReceptsItem>> SendMessage() {
        CompletableFuture<ArrayList<ReceptsItem>> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId , new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) throws Exception {
                Log.i("WebSocket", Arrays.toString(parts));

                ArrayList arrayList = new ArrayList(Arrays.asList(parts));
                arrayList.remove(0);
                arrayList.remove(0);

                Log.i("WebSocket", "message has been sent");
            }
        });

        Log.i("WebSocket", "SendMessage");
        SendRequest(requestId, "GetRecomendsRecepts", "");

        return future;
    }

    public CompletableFuture<ArrayList<ReceptsItem>> getRecomendsRecepts(){
        CompletableFuture<ArrayList<ReceptsItem>> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) {

            }
        });

        Log.i("WebSocket", "Try get recepts");
        SendRequest(requestId, "GetRecomendsRecepts", "");

        return future;
    }

    public CompletableFuture<ArrayList<ReceptsItem>> GetRecepts(int from, int to){
        CompletableFuture<ArrayList<ReceptsItem>> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) {
                Log.i("WebSocket", Arrays.toString(parts));
                if (Objects.equals(parts[1], "true")) {
                    // Преобразование в ArrayList и удаление первых двух элементов
                    ArrayList arrayList = new ArrayList(Arrays.asList(parts));
                    arrayList.remove(0);
                    arrayList.remove(0);

                    String joinedString = String.join(" ", arrayList);
                    String[] splitArray = joinedString.split("_text_");
                    ArrayList<String> resultList = new ArrayList<String>(Arrays.asList(splitArray));
                    for (int i = 0; i < resultList.size(); i++){
                        if (resultList.get(i).length() <= 1) {
                            resultList.remove(i);
                            i--;
                        }
                    }
                    Log.i("WebSocket", "All Recepts Collect");


                    ArrayList<ReceptsItem> receptsItems = new ArrayList<>();
                    for (int i = 0; i < resultList.size(); i++){
                        ArrayList<String> preClassArray = new ArrayList<String>
                                (Arrays.asList(resultList.get(i).split(" . ")));
                        int id = Integer.parseInt(preClassArray.get(0));
                        String label = preClassArray.get(1);
                        label = label.substring(3, label.length() - 4);
                        ArrayList<String> products = new ArrayList<>
                                (Arrays.asList(preClassArray.get(2).split(",")));
                        ArrayList<String> users = new ArrayList<>
                                (Arrays.asList(preClassArray.get(3).split(",")));
                        ArrayList<String> tags = new ArrayList<>
                                (Arrays.asList(preClassArray.get(4).split(",")));

                        ReceptsItem receptsItem = new ReceptsItem
                                (id, label, "-", -1, products, users, tags);
                        receptsItems.add(receptsItem);
                    }

                    future.complete(receptsItems);
                } else {
                    future.complete(null);
                }
            }
        });

        Log.i("WebSocket", "Try get recepts");
        SendRequest(requestId, "GetRecepts", from + " " + to);

        return future;
    }

    public CompletableFuture<ReceptsItem> GetRecept(ReceptsItem receptItem){
        CompletableFuture<ReceptsItem> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId , new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) {
                Log.i("WebSocket", Arrays.toString(parts));
                if (Objects.equals(parts[1], "true")) {
                    // Преобразование в ArrayList и удаление первых двух элементов
                    ArrayList arrayList = new ArrayList(Arrays.asList(parts));
                    arrayList.remove(0);
                    arrayList.remove(0);

                    String joinedString = String.join(" ", arrayList);
                    Log.i("WebSocket", "Recept Collect");

                    receptItem.setText(joinedString);

                    future.complete(receptItem);
                } else {
                    future.complete(null);
                }
            }
        });

        Log.i("WebSocket", "Try get recept");
        SendRequest(requestId, "GetRecept", String.valueOf(receptItem.getId()));

        return future;
    }

    public CompletableFuture<Boolean> Login(String login, String password) {
        CompletableFuture<Boolean> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) {
                Log.i("WebSocket", "Return login");
                if (Objects.equals(parts[1], "true")) {
                    future.complete(true);
                } else {
                    future.complete(false);
                }
            }
        });

        Log.i("WebSocket", "Try login");
        SendRequest(requestId, "Login", login + " " + password);

        return future;
    }

    public CompletableFuture<Boolean> Like(int id) {
        CompletableFuture<Boolean> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) {
                Log.i("WebSocket", "Return Like");
                if (Objects.equals(parts[1], "true")) {
                    future.complete(true);
                } else {
                    future.complete(false);
                }
            }
        });

        Log.i("WebSocket", "Try Like");
        SendRequest(requestId, "Like", String.valueOf(id));

        return future;
    }

    public CompletableFuture<Boolean> GetLike(int id) {
        CompletableFuture<Boolean> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) {
                Log.i("WebSocket", "Return Like");
                if (Objects.equals(parts[1], "true")) {
                    future.complete(true);
                } else {
                    future.complete(false);
                }
            }
        });

        Log.i("WebSocket", "Try Get Like");
        SendRequest(requestId, "IsLike", String.valueOf(id));

        return future;
    }

    public CompletableFuture<Boolean> Dislike(int id) {
        CompletableFuture<Boolean> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) {
                Log.i("WebSocket", "Return Dislike");
                if (Objects.equals(parts[1], "true")) {
                    future.complete(true);
                } else {
                    future.complete(false);
                }
            }
        });

        Log.i("WebSocket", "Try Dislike");
        SendRequest(requestId, "Dislike", String.valueOf(id));

        return future;
    }

    public CompletableFuture<Boolean> GetDislike(int id) {
        CompletableFuture<Boolean> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) {
                Log.i("WebSocket", "Return Dislike");
                if (Objects.equals(parts[1], "true")) {
                    future.complete(true);
                } else {
                    future.complete(false);
                }
            }
        });

        Log.i("WebSocket", "Try Get Dislike");
        SendRequest(requestId, "IsDislike", String.valueOf(id));

        return future;
    }

    public CompletableFuture<Boolean> Favorite(int id) {
        CompletableFuture<Boolean> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) {
                Log.i("WebSocket", "Return Favorite");
                if (Objects.equals(parts[1], "true")) {
                    future.complete(true);
                } else {
                    future.complete(false);
                }
            }
        });

        Log.i("WebSocket", "Try Favorite");
        SendRequest(requestId, "Favorite", String.valueOf(id));

        return future;
    }

    public CompletableFuture<Boolean> GetFavorite(int id) {
        CompletableFuture<Boolean> future = new CompletableFuture<>();
        int requestId = GetK();

        setOnMessageReceivedListener(requestId, new OnMessageReceived() {
            @Override
            public void onMessage(String[] parts) {
                Log.i("WebSocket", "Return Favorite");
                if (Objects.equals(parts[1], "true")) {
                    future.complete(true);
                } else {
                    future.complete(false);
                }
            }
        });

        Log.i("WebSocket", "Try Get Favorite");
        SendRequest(requestId, "IsFavorite", String.valueOf(id));

        return future;
    }
}
