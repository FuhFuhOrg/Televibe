package com.example.teletypesha.jsons;

import android.content.Context;
import android.util.Log;

import com.example.teletypesha.itemClass.Chat;
import com.example.teletypesha.itemClass.User;
import com.google.gson.Gson;
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
import java.util.ArrayList;
import java.util.HashMap;

public class JsonDataSaver implements Serializable  {
    private static JSONObject data = new JSONObject();
    static String filename = "SavedChats.json";

    public static ArrayList<Chat> TryLoadChats(Context context) {
        JSONObject jsonObject = TryLoadJson(context);
        String jsonChats = null;
        try {
            jsonChats = jsonObject.getString("chats");
        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
        Type listType = new TypeToken<ArrayList<Chat>>(){}.getType();
        ArrayList<Chat> chats = new Gson().fromJson(jsonChats, listType);

        Log.i("JsonDataSaver", "Данные успешно загружены");

        return chats;
    }
    public static void SaveChats(ArrayList<Chat> chats, Context context){
        Gson gson = new Gson();
        Object json = gson.toJson(chats);
        try {
            Add("chats", json);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        SaveToFile(context);
    }

    private static void SaveToFile(Context context) {
        File file = new File(context.getFilesDir(), filename);
        try (FileWriter fileWriter = new FileWriter(file)) {
            fileWriter.write(data.toString());
            Log.i("JsonDataSaver", "Данные успешно сохранены в " + file.getAbsolutePath());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }






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
