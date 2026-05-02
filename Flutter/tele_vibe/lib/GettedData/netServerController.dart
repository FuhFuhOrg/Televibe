import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:tele_vibe/Data/chats.dart';
import 'package:tele_vibe/GettedData/cryptController.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class NetServerController with WidgetsBindingObserver {
  static const String s = "95.165.27.159";
  static WebSocketChannel? webSocketChannel;
  static int k = 0;
  static Map<int, Function(List<String>)> listeners = {};
  bool _isReconnecting = false;
  bool _isStarted = false;
  bool _isConnecting = false;
  StreamSubscription<dynamic>? _webSocketSubscription;
  static const int reconnectDelaySeconds = 5;
  static bool reconnectEnabled = true;

  static final NetServerController _instance = NetServerController._internal();

  factory NetServerController() {
    return _instance;
  }

  NetServerController._internal();

  void start() {
    if (!_isStarted) {
      WidgetsBinding.instance.addObserver(this);
      _isStarted = true;
    }

    if (webSocketChannel == null || webSocketChannel!.closeCode != null) {
      _connect();
    }
  }

  void _connect() {
    if (_isConnecting) return;

    final uri = Uri.parse("ws://$s:17825/");
    _isConnecting = true;
    try {
      _webSocketSubscription?.cancel();
      final channel = WebSocketChannel.connect(uri);
      webSocketChannel = channel;

      _webSocketSubscription = channel.stream.listen((message) {
        onTextReceived(message);
      }, onDone: () {
        debugPrint('WebSocket closed');
        if (identical(webSocketChannel, channel)) {
          webSocketChannel = null;
        }
        _attemptReconnect();
      }, onError: (error) {
        debugPrint('WebSocket error: $error');
        if (identical(webSocketChannel, channel)) {
          webSocketChannel = null;
        }
        _attemptReconnect();
      });
      // Suppress unhandled-exception from the ready future; errors are
      // already handled by the stream's onError / onDone callbacks above.
      channel.ready.catchError((e) {
        debugPrint('WebSocket ready error (suppressed): $e');
      });
    } catch (e) {
      debugPrint('Error connecting to WebSocket: $e');
      _attemptReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  // Функция для попытки переподключения
  void _attemptReconnect() {
    if (_isReconnecting || !reconnectEnabled) {
      return; // Проверяем, уже ли идет попытка переподключения или reconnect отключён
    }
    _isReconnecting = true;

    Future.delayed(const Duration(seconds: reconnectDelaySeconds), () {
      debugPrint('Attempting to reconnect...');
      _connect();
      _isReconnecting = false; // Сбрасываем флаг после попытки
    });
  }

  void onTextReceived(String message) {
    List<String> parts = message.split(" ");
    if (parts.isEmpty || int.tryParse(parts[0]) == null) {
      debugPrint('Invalid message format: $message');
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
      debugPrint('Error: $e');
    }
  }

  void setOnMessageReceivedListener(int id, Function(List<String>) listener) {
    listeners[id] = listener;
  }

  void sendRequest(int id, String requestWord, String message) {
    final channel = webSocketChannel;
    if (channel != null && channel.closeCode == null) {
      try {
        channel.sink.add("/sql $requestWord $id $message");
        return;
      } catch (error) {
        debugPrint("WebSocket send failed: $error");
      }
    }

    debugPrint("WebSocket is not connected. Reconnecting...");
    _connect();
  }

  void sendUnregistredRequest(String message) {
    final channel = webSocketChannel;
    if (channel != null && channel.closeCode == null) {
      try {
        channel.sink.add(message);
        return;
      } catch (error) {
        debugPrint("WebSocket send failed: $error");
      }
    }

    debugPrint("WebSocket is not connected. Reconnecting...");
    _connect();
  }

  Future<T> _withRequestTimeout<T>(
    int requestId,
    Future<T> future,
    T fallback,
    Duration timeout,
  ) {
    return future.timeout(timeout, onTimeout: () {
      listeners.remove(requestId);
      debugPrint('Request $requestId timed out');
      return fallback;
    });
  }

  int getK() {
    k++;
    if (k >= 1000000) {
      k = 0;
    }
    return k;
  }

  // Requests to the server

  Future<bool> isApiAvailable({
    Duration timeout = const Duration(milliseconds: 1400),
  }) async {
    final response = await login(
      '__televibe_probe__',
      '__televibe_probe__',
      timeout: timeout,
    );
    return response.isNotEmpty;
  }

//OK
  Future<List<String>> createNewChat(
      String chatPassword, bool isPrivacy) async {
    Completer<List<String>> completer = Completer<List<String>>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts);
      }
    });

    final encryptedPassword =
        CryptController.encryptAES(chatPassword, chatPassword);
    debugPrint("$encryptedPassword $isPrivacy");
    sendRequest(requestId, "ChatCreate", "$encryptedPassword $isPrivacy");
    return _withRequestTimeout(
      requestId,
      completer.future,
      <String>[],
      const Duration(seconds: 5),
    );
  }

//OK
  Future<List<String>> addUserToChat(
      RSAPublicKey publicKey,
      RSAPrivateKey privateKey,
      String idChat,
      String chatPassword,
      int? anonId,
      String? password,
      String? username,
      Image? img) async {
    if (anonId == null || password == null) {
      return [];
    }

    Completer<List<String>> completer = Completer<List<String>>();
    int requestId = getK();

    // Шифруем ключи через CryptController
    String encryptedPublicKey = CryptController.encryptPublicKey(
        CryptController.encodePublicKey(publicKey),
        idChat,
        chatPassword,
        anonId,
        password);
    String encryptedPrivateKey = CryptController.encryptPrivateKey(
        CryptController.encodePrivateKey(privateKey), idChat, chatPassword);
    String encryptedAnonId = CryptController.encryptAnonId(
        anonId.toString(), idChat, chatPassword, password);

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts);
      } else {
        completer.complete([]);
      }
    });

    String image = img != null ? await Subuser.imageToBase64(img) : "";
    sendRequest(requestId, "AddUserToChat",
        "$encryptedPublicKey $encryptedPrivateKey $idChat $encryptedAnonId $username $image");

    return _withRequestTimeout(
      requestId,
      completer.future,
      <String>[],
      const Duration(seconds: 6),
    );
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

    sendRequest(requestId, "DeleteChat", chatId);
    return _withRequestTimeout(
      requestId,
      completer.future,
      false,
      const Duration(seconds: 5),
    );
  }

//OK
  Future<List<String>> getChatUser(String chatId) async {
    Completer<List<String>> completer = Completer<List<String>>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts);
      } else {
        completer.complete([]);
      }
    });

    sendRequest(requestId, "SendChatUsers", chatId);
    return _withRequestTimeout(
      requestId,
      completer.future,
      <String>[],
      const Duration(seconds: 5),
    );
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
  Future<String> sendMessage(String preference, String msg, String chatId,
      int idSender, RSAPublicKey publicKey) async {
    Completer<String> completer = Completer<String>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts[0]);
      } else {
        completer.complete("");
      }
    });

    // Кодируем сообщение в base64
    String encodedMsg = base64Encode(
        utf8.encode(CryptController.encryptRSA("$preference $msg", publicKey)));

    // Формируем запрос в нужном формате: requestId chatId idSender encodedMsg
    sendRequest(requestId, "SendMessage", "$chatId $idSender $encodedMsg");

    return _withRequestTimeout(
      requestId,
      completer.future,
      "",
      const Duration(seconds: 6),
    );
  }

//RW
  Future<List<String>> getMessages(String chatId, int lastQueueId) async {
    Completer<List<String>> completer = Completer<List<String>>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts);
      } else {
        completer.complete([]);
      }
    });

    sendRequest(requestId, "GetQueueMessages", "$chatId $lastQueueId");
    return _withRequestTimeout(
      requestId,
      completer.future,
      <String>[],
      const Duration(seconds: 4),
    );
  }

//ERROR
  Future<String> deleteMessage(int idSender, int idMsg) async {
    Completer<String> completer = Completer<String>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.length > 1) {
        completer.complete(parts[1]);
      } else {
        completer.complete("");
      }
    });

    sendRequest(requestId, "DeleteMessages", "$idSender $idMsg");
    return _withRequestTimeout(
      requestId,
      completer.future,
      "",
      const Duration(seconds: 5),
    );
  }

//ERROR
  Future<String> refactorMessage(int idMsg, int idSender, List<int> msg) async {
    Completer<String> completer = Completer<String>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts[0]);
      } else {
        completer.complete("");
      }
    });

    sendRequest(
        requestId, "RefactorMessage", "$idMsg $idSender ${base64Encode(msg)}");
    return _withRequestTimeout(
      requestId,
      completer.future,
      "",
      const Duration(seconds: 5),
    );
  }

//OK
  Future<List<String>> login(
    String log,
    String pass, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    Completer<List<String>> completer = Completer<List<String>>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts);
      } else {
        completer.complete([]);
      }
    });

    sendRequest(requestId, "Login",
        "${CryptController.encryptAES(log, log)} ${CryptController.encryptAES(pass, pass)}");
    return completer.future.timeout(timeout, onTimeout: () {
      listeners.remove(requestId);
      return [];
    });
  }

//OK
  Future<List<String>> register(String log, String pass) async {
    Completer<List<String>> completer = Completer<List<String>>();
    int requestId = getK();

    setOnMessageReceivedListener(requestId, (parts) {
      if (parts.isNotEmpty) {
        completer.complete(parts);
      } else {
        completer.complete([]);
      }
    });
    String regdata = "  ";

    sendRequest(requestId, "AltRegister",
        "${CryptController.encryptAES(log, log)} ${CryptController.encryptAES(pass, pass)} ${CryptController.encryptAES(regdata, "")}");
    return _withRequestTimeout(
      requestId,
      completer.future,
      <String>[],
      const Duration(seconds: 5),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Restart WebSocket connection if needed when the app resumes
      start();
    }
  }

  void dispose() {
    if (_isStarted) {
      WidgetsBinding.instance.removeObserver(this);
      _isStarted = false;
    }
    _webSocketSubscription?.cancel();
    _webSocketSubscription = null;
    webSocketChannel?.sink.close(status.goingAway);
    webSocketChannel = null;
  }
}
