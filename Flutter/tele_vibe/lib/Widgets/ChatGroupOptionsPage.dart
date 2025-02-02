import 'package:flutter/material.dart';
import 'package:tele_vibe/ViewModel/chatGroupOptionVM.dart';

class ChatGroupOptionsPage extends StatefulWidget {
  const ChatGroupOptionsPage({super.key});

  @override
  _ChatGroupOptionsPageState createState() => _ChatGroupOptionsPageState();
}

class _ChatGroupOptionsPageState extends State<ChatGroupOptionsPage> {
  bool _isCreatingGroup = false;
  bool _isAddingChat = false;

  // Переменные для хранения данных
  String _groupName = '';
  String _groupPassword = '';
  String _textField = "";
  String _chatPassword = '', _chatId = '';

  // Контроллеры для текстовых полей
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupPasswordController = TextEditingController();
  final TextEditingController _chatPasswordController = TextEditingController();
  final TextEditingController  _groupHostController = TextEditingController();
  final TextEditingController  _chatIdController = TextEditingController();
  final ChatGroupOptionVM _chatGroupOptionVM = ChatGroupOptionVM();
  bool _isPasswordRequired = false;
  

  // Переменные для хранения данных
  String _groupHost = '';
  String _addChatPassword = '';

  // ПРОШУ ИЛЬЯ ПИШИ ЭТО ПРОЩУ
  @override
  void initState() {
    super.initState();
  }
  // ПРОШУ ИЛЬЯ ПИШИ ЭТО ПРОЩУ, ЭТО ТОЖЕ
  @override
  void dispose() {
    _chatGroupOptionVM.dispose();
    _groupNameController.dispose();
    _groupPasswordController.dispose();
    _chatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text(
          "Создание/Добавление чата",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF141414),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Центрирование по ширине
          mainAxisAlignment: MainAxisAlignment.start, // Прижимаем все к верху
          children: [
            Center( // Центрируем первую кнопку
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isCreatingGroup = true;
                    _isAddingChat = false;
                  });
                },
                child: const Text("Создать чат/группу"),
              ),
            ),
            const SizedBox(height: 16), // Отступ между кнопками
            Center( // Центрируем вторую кнопку
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isAddingChat = true;
                    _isCreatingGroup = false;
                  });
                },
                child: const Text("Добавить чат/группу"),
              ),
            ),
            const SizedBox(height: 32), // Отступ перед полями ввода
            if (_isCreatingGroup) ...[
              TextField(
                controller: _groupNameController,
                onChanged: (value) {
                  setState(() {
                    _groupName = value; // Сохранение названия группы
                  });
                },
                decoration: const InputDecoration(labelText: "Название группы"),
              ),
              TextField(
                controller: _groupPasswordController,
                onChanged: (value) {
                  setState(() {
                    _groupPassword = value; // Сохранение пароля группы
                  });
                },
                decoration: const InputDecoration(labelText: "Пароль (если нужен)"),
                obscureText: true,
              ),
              TextField(
                controller: _groupHostController,
                onChanged: (value) {
                  setState(() {
                    _groupHost = value; // Сохранение пароля группы
                  });
                },
                decoration: const InputDecoration(labelText: "Текстовое поле"),
                obscureText: true,
              ),
              SwitchListTile(
                title: const Text("Чат/группа?", style: TextStyle(color: Colors.white)),
                value: _isPasswordRequired,
                onChanged: (value) {
                  setState(() {
                    _isPasswordRequired = value;
                  });
                },
              ),
            ],
            if (_isAddingChat) ...[
              // Текстовое поле для ввода ID чата
              TextField(
                controller: _chatIdController,
                onChanged: (value) {
                  setState(() {
                    _chatId = value; // Сохранение ID чата
                  });
                },
                decoration: const InputDecoration(labelText: "ID чата"),
              ),
              // Текстовое поле для ввода пароля
              TextField(
                controller: _chatPasswordController,
                onChanged: (value) {
                  setState(() {
                    _chatPassword = value; // Сохранение пароля чата
                  });
                },
                decoration: const InputDecoration(labelText: "Пароль"),
                obscureText: true,
              ),
              // Текстовое поле для ввода пароля
              TextField(
                controller: _chatPasswordController,
                onChanged: (value) {
                  setState(() {
                    _chatPassword = value; // Сохранение пароля чата
                  });
                },
                decoration: const InputDecoration(labelText: "ИЛЮША БЛЯДЬ НЕ ТРОГАЙ"),
                obscureText: true,
              ),
            ]
          ],
        ),
      ),
      bottomNavigationBar: _isCreatingGroup || _isAddingChat
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_isCreatingGroup) {
                    _chatGroupOptionVM.createChat(context, _groupName, _groupPassword, _groupHost, true);
                    // Логика создания группы с сохраненными данными
                    print("Создание группы: $_groupName с паролем: $_groupPassword");
                  } else if (_isAddingChat) {
                    _chatGroupOptionVM.enterInChat(context, _groupName, _chatId, _groupPassword, _groupHost);
                    // Логика добавления чата с сохраненными данными
                    print("Добавление чата с паролем: $_addChatPassword");
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Кнопка по ширине экрана
                ),
                child: Text(_isCreatingGroup ? "Создать" : "Добавить"),
              ),
            )
          : null,
    );
  }
}
