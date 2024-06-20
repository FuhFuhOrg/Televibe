package com.example.teletypesha.jsons;

import android.content.Context;
import android.util.Log;

import com.example.teletypesha.activitys.MainActivity;
import com.example.teletypesha.crypt.KeySerializer;
import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.User;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.InstanceCreator;
import com.google.gson.reflect.TypeToken;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Serializable;
import java.lang.reflect.Type;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.util.ArrayList;
import java.util.HashMap;

public class JsonDataSaver implements Serializable  {
    private static JSONObject data = new JSONObject();
    static String filename = "SavedChats.json";
    static Gson gson;

    // (**) Перенести создание в if gson != null => эта функция
    // Создает gson
    public static void AwakeJson(){
        GsonBuilder gsonBuilder = new GsonBuilder();
        gsonBuilder.registerTypeAdapter(PrivateKey.class, new KeySerializer());
        gsonBuilder.registerTypeAdapter(PublicKey.class, new KeySerializer());
        gson = gsonBuilder.create();
    }

    // (*)
    // Сохраняет все данные в локальный файл
    public static void SaveAll(Context context, JSONObject json) {
        File file = new File(context.getFilesDir(), filename);
        try (FileWriter fileWriter = new FileWriter(file)) {
            JSONObject extractedObject = json.getJSONObject("nameValuePairs");
            fileWriter.write(extractedObject.toString()); // Ensures proper JSON formatting
            Log.i("JsonDataSaver", "Data successfully saved to " + file.getAbsolutePath());
        } catch (IOException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
    }

    // (+)
    // Читает Json без проебразований
    public static JSONObject TryLoadChatsWithoutRead(Context context){
        Log.i("Chats", "Данные начали загрузку");

        JSONObject jsonObject = TryLoadJson(context);
        return jsonObject;
    }


    // (*)
    // Читает Json и преобразует в чаты и информацию
    public static ArrayList<Chat> TryLoadChats(Context context) {

        Log.i("Chats", "Данные начали загрузку");

        JSONObject jsonObject = TryLoadJson(context);

        String jsonChats = null;
        if(jsonObject != null) {
            try {
                String login = jsonObject.getString("login");
                if (login != null){
                    MainActivity.login = login;
                }
            } catch (JSONException e) {
                Log.e("JsonDataSaver", "Login field not found in JSON, setting login to null.");
            }

            try {
                String password = jsonObject.getString("password");
                if (password != null) {
                    MainActivity.password = password;
                }
            } catch (JSONException e) {
                Log.e("JsonDataSaver", e.toString());
            }

            try {
                jsonChats = jsonObject.getString("chats");
            } catch (JSONException e) {
                Log.e("JsonDataSaver", e.toString());
                return null;
            }
        } else {
            Log.e("JsonDataSaver", "jsonObject is null");
            return null;
        }

        Log.i("Chats", "Данные начали переработку");

        Type listType = new TypeToken<ArrayList<Chat>>(){}.getType();
        ArrayList<Chat> chats = gson.fromJson(jsonChats, listType);

        Log.i("Chats", "Данные успешно загружены");

        return chats;
    }

    // (*)
    // Сохранят в Json чаты и информацию
    public static void SaveChats(ArrayList<Chat> chats, Context context){
        try {
            Add("login", MainActivity.login);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        try {
            Add("password", MainActivity.password);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        Object json = gson.toJson(chats);
        try {
            Add("chats", json);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        SaveToFile(context);
    }

    // (*)
    // Сохранят data в файл json
    private static void SaveToFile(Context context) {
        File file = new File(context.getFilesDir(), filename);
        try (FileWriter fileWriter = new FileWriter(file)) {
            fileWriter.write(data.toString());
            Log.i("JsonDataSaver", "Данные успешно сохранены в " + file.getAbsolutePath());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }






    // (**) часто вылетает
    // Сохранят data в файл json
    private static JSONObject TryLoadJson(Context context){
        File file = new File(context.getFilesDir(), filename);
        if (file.exists()) {
            try {
                String content = new String(Files.readAllBytes(file.toPath()), StandardCharsets.UTF_8);
                return new JSONObject(content);
            } catch (IOException | JSONException e) {
                Log.e("JsonDataSaver", "Ошибка при чтении файла", e);
            }
        } else {
            Log.i("JsonDataSaver", "Файл не найден");
        }
        return null;
    }

    private static void Add(String key, Object value) throws JSONException {
        data.put(key, value);
    }
}
