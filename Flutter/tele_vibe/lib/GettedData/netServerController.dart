import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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

  Future<String> createNewChat(String chatPassword, bool isPrivacy) async {
    Completer<String> completer = Completer<String>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts[0]);
      }
    });

    sendRequest(requestId, "ChatCreate", "$isPrivacy $chatPassword");
    return completer.future;
  }

  Future<String> addUserToChat(String publicKey, String idChat, String chatPassword) async {
    Completer<String> completer = Completer<String>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts[0]);
      } else {
        completer.complete(null);
      }
    });

    sendRequest(requestId, "addUserToChat", "$publicKey $idChat $chatPassword");
    return completer.future;
  }

  Future<String> sendMessage(List<int> msg, int idSender, DateTime timeMsg) async {
    Completer<String> completer = Completer<String>();
    int requestId = getK();
    String timeWithoutMilliseconds = timeMsg.toIso8601String().split('.').first;

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts[0]);
      } else {
        completer.complete(null);
      }
    });

    sendRequest(requestId, "SendMessage", "$idSender $timeWithoutMilliseconds ${base64Encode(msg)}");
    return completer.future;
  }

  Future<List<String>> getMessages(String str) async {
    Completer<List<String>> completer = Completer<List<String>>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts);
      } else {
        completer.complete([]);
      }
    });

    sendRequest(requestId, "GetMessages", str);
    return completer.future;
  }

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
