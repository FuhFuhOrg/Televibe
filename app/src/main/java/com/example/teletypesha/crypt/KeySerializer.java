package com.example.teletypesha.crypt;

import java.lang.reflect.Type;
import java.security.*;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;
import com.google.gson.*;

public class KeySerializer implements JsonSerializer<Key>, JsonDeserializer<Key> {
    // Сериализует Ключ
    @Override
    public JsonElement serialize(Key key, Type type, JsonSerializationContext jsonSerializationContext) {
        return new JsonPrimitive(Base64.getEncoder().encodeToString(key.getEncoded()));
    }

    // Десериализует Ключ
    @Override
    public Key deserialize(JsonElement jsonElement, Type type, JsonDeserializationContext jsonDeserializationContext) throws JsonParseException {
        try {
            byte[] decodedKey = Base64.getDecoder().decode(jsonElement.getAsString());
            if (type.equals(PrivateKey.class)) {
                return KeyFactory.getInstance("RSA").generatePrivate(new PKCS8EncodedKeySpec(decodedKey));
            } else if (type.equals(PublicKey.class)) {
                return KeyFactory.getInstance("RSA").generatePublic(new X509EncodedKeySpec(decodedKey));
            }
        } catch (Exception e) {
            throw new JsonParseException(e);
        }
        return null;
    }
}
