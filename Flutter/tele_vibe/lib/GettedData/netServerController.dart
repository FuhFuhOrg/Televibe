import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:tele_vibe/GettedData/cryptController.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class NetServerController with WidgetsBindingObserver {
  static const String s = "95.165.27.159";
  static WebSocketChannel? webSocketChannel;
  static int k = 0;
  static Map<int, Function(List<String>)> listeners = {};
  bool _isReconnecting = false;
  static const int reconnectDelaySeconds = 5;

  static final NetServerController _instance = NetServerController._internal();

  factory NetServerController() {
    return _instance;
  }

  NetServerController._internal();

  void start() {
    WidgetsBinding.instance.addObserver(this);
    _connect();
  }

  void _connect() {
    final uri = Uri.parse("ws://$s:17825/");
    try {
      webSocketChannel = WebSocketChannel.connect(uri);

      webSocketChannel!.stream.listen((message) {
        onTextReceived(message);
      }, onDone: () {
        print('WebSocket closed');
        _attemptReconnect();
      }, onError: (error) {
        print('WebSocket error: $error');
        _attemptReconnect();
      });
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      _attemptReconnect();
    }
  }

  // Функция для попытки переподключения
  void _attemptReconnect() {
    if (_isReconnecting) return; // Проверяем, уже ли идет попытка переподключения
    _isReconnecting = true;

    Future.delayed(const Duration(seconds: reconnectDelaySeconds), () {
      print('Attempting to reconnect...');
      _connect();
      _isReconnecting = false; // Сбрасываем флаг после попытки
    });
  }

  void onTextReceived(String message) {
  List<String> parts = message.split(" ");
  if (parts.isEmpty || int.tryParse(parts[0]) == null) {
    print('Invalid message format: $message');
    return;
  }
  try {
    int id = int.parse(parts[0]);
    var listener = listeners[id];
    if (listener != null) {
      listener(parts.sublist(1));
      listeners.remove(id);
    }
  } catch (e) {
    print('Error: $e');
  }
}

  void setOnMessageReceivedListener(int id, Function(List<String>) listener) {
    listeners[id] = listener;
  }

  void sendRequest(int id, String requestWord, String message) {
    if (webSocketChannel != null && webSocketChannel!.closeCode == null) {
      webSocketChannel!.sink.add("/sql $requestWord $id $message");
    } else {
      print("WebSocket is not connected. Reconnecting...");
      _connect();
    }
  }

  void sendUnregistredRequest(String message) {
    if (webSocketChannel != null && webSocketChannel!.closeCode == null) {
      webSocketChannel!.sink.add(message);
    } else {
      print("WebSocket is not connected. Reconnecting...");
      _connect();
    }
  }

  int getK() {
    k++;
    if (k >= 1000000) {
      k = 0;
    }
    return k;
  }

  // Requests to the server


//OK
  Future<List<String>> createNewChat(String chatPassword, bool isPrivacy) async {
    Completer<List<String>> completer = Completer<List<String>>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts);
      }
    });

    print("${CryptController.encryptAES(chatPassword, chatPassword)} $isPrivacy");
    sendRequest(requestId, "ChatCreate", "${CryptController.encryptAES(chatPassword, chatPassword)} $isPrivacy");
    return completer.future;
  }


//OK
  Future<List<String>> addUserToChat(RSAPublicKey publicKey, RSAPrivateKey privateKey, 
    String idChat, String chatPassword, int? anonId, String? password) async 
  {
    Completer<List<String>> completer = Completer<List<String>>();
    int requestId = getK();

    // Шифруем ключи через CryptController
    String encryptedPublicKey = CryptController.encryptPublicKey(CryptController.encodePublicKey(publicKey), idChat, chatPassword, anonId!, password!);
    String encryptedPrivateKey = CryptController.encryptPrivateKey(CryptController.encodePrivateKey(privateKey), idChat, chatPassword);
    String encryptedAnonId = CryptController.encryptAnonId(anonId.toString(), idChat, chatPassword, password!);

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts);
      } else {
        completer.complete(null);
      }
    });

    sendRequest(requestId, "AddUserToChat", 
    "$encryptedPublicKey $encryptedPrivateKey $idChat $encryptedAnonId");
    return completer.future;
  }


//OK
  Future<bool> deleteGroup(String chatId) async {
    Completer<bool> completer = Completer<bool>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(true);
      } else {
        completer.complete(false);
      }
    });

    sendRequest(requestId, "DeleteChat", "$chatId");
    return completer.future;
  }

//OK
  Future<List<String>> getChatUser(String chatId) async {
    
    Completer<List<String>> completer = Completer<List<String>>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts);
      } else {
        completer.complete(null);
      }
    });

    sendRequest(requestId, "SendChatUsers", 
    "$chatId");
    return completer.future;
  }






  String xorEncrypt(String data, String key) {
    List<int> dataBytes = utf8.encode(data);
    List<int> keyBytes = utf8.encode(key);
    List<int> encryptedBytes = [];

    for (int i = 0; i < dataBytes.length; i++) {
      encryptedBytes.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return base64Encode(encryptedBytes);
  }


//OK
  Future<String> sendMessage(String msg, String chatId, int idSender, RSAPublicKey publicKey) async {
    Completer<String> completer = Completer<String>();
    int requestId = getK();
    
    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts[0]);
      } else {
        completer.complete(null);
      }
    });

    // Кодируем сообщение в base64
    String encodedMsg = CryptController.encryptRSA("+ ${msg}", publicKey);

    // Формируем запрос в нужном формате: данные + id пользователя
    sendRequest(requestId, "SendMessage", "$chatId $idSender $encodedMsg");

    return completer.future;
  }


//RW
  Future<List<String>> getMessages(String chatId, int lastQueueId) async {
    Completer<List<String>> completer = Completer<List<String>>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts);
      } else {
        completer.complete(null);
      }
    });

    sendRequest(requestId, "GetQueueMessages", 
    "${chatId} ${lastQueueId}");
    return completer.future;
  }


//ERROR
  Future<String> deleteMessage(int idSender, int idMsg) async {
    Completer<String> completer = Completer<String>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.length > 1) {
        completer.complete(parts[1]);
      } else {
        completer.complete(null);
      }
    });

    sendRequest(requestId, "DeleteMessages", "$idSender $idMsg");
    return completer.future;
  }


//ERROR
  Future<String> refactorMessage(int idMsg, int idSender, List<int> msg) async {
    Completer<String> completer = Completer<String>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts[0]);
      } else {
        completer.complete(null);
      }
    });

    sendRequest(requestId, "RefactorMessage", "$idMsg $idSender ${base64Encode(msg)}");
    return completer.future;
  }


//OK
  Future<List<String>> login(String log, String pass) async {
    Completer<List<String>> completer = Completer<List<String>>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts);
      } else {
        completer.complete(null);
      }
    });

    sendRequest(requestId, "Login", 
    "${CryptController.encryptAES(log, log)} ${CryptController.encryptAES(pass, pass)}");
    return completer.future;
  }


//OK
  Future<List<String>> register(String log, String pass) async {
    Completer<List<String>> completer = Completer<List<String>>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts);
      } else {
        completer.complete(null);
      }
    });
    String regdata = "  ";

    sendRequest(requestId, "AltRegister", 
    "${CryptController.encryptAES(log, log)} ${CryptController.encryptAES(pass, pass)} ${CryptController.encryptAES(regdata, "")}");
    return completer.future;
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Restart WebSocket connection if needed when the app resumes
      start();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    webSocketChannel?.sink.close(status.goingAway);
  }
}
