import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tele_vibe/Data/user.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart' as myHandler;
import 'package:tele_vibe/ViewModel/changeVeluesInProfileScreenVM.dart';

import 'UnderWidgets/fileUtils.dart';
import 'renameTextField.dart';

class ProfileScreen extends StatefulWidget {
  final String nickname;

  const ProfileScreen({super.key, required this.nickname});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nickname = '';
  String _phoneNumber = '';
  String _username = '';
  String _about = '';
  String? _profileImagePath;
  final changeVeluesInProfileScreenVM changeProfileScreenVM = changeVeluesInProfileScreenVM();
  late Future<void> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  // Загружаем сохранённые данные профиля
  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nickname = prefs.getString('nickname') ?? (Anon.anonIdGet?.toString() ?? 'Unknown');
    _username = prefs.getString('username') ?? Anon.username;
    _profileImagePath = prefs.getString('profileImagePath');
    Anon.image = Image.file(
        File(_profileImagePath!),
        fit: BoxFit.cover,
      );
  }

  // Сохраняем данные профиля
  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nickname', _nickname);
    await prefs.setString('username', _username);
    if (_profileImagePath != null) {
      await prefs.setString('profileImagePath', _profileImagePath!);
    }
  }

  // Метод для перехода на экран изменения текста
  void _navigateToEditScreen(String title, String currentText, Function(String) onSave) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RenameTextField(title: title, currentText: currentText),
      ),
    );
    if (result != null) {
      onSave(result);
      _saveProfile();
      setState(() {}); // Обновляем состояние после сохранения
    }
  }

  // Возвращает виджет изображения профиля с проверкой на существование файла
  Widget _buildProfileImage() {
    if (_profileImagePath != null && File(_profileImagePath!).existsSync()) {
      return Image.file(
        File(_profileImagePath!),
        fit: BoxFit.cover,
      );
    } else {
      return Anon.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Color(0xFF141414),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFF141414),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.grey,
                expandedHeight: MediaQuery.of(context).size.height * 3 / 7,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildProfileImage(),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _nickname,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  collapseMode: CollapseMode.parallax,
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () {
                      _navigateToEditScreen('никнейм', _nickname, (newUserName) {
                        setState(() {
                          _nickname = newUserName;
                          changeProfileScreenVM.changeUsername(newUserName);
                        });
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.black),
                    onPressed: () {
                      _showProfileOptions(context);
                    },
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Аккаунт',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        'ID пользователя',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: GestureDetector(
                        onLongPress: () {
                          Clipboard.setData(ClipboardData(text: Anon.anonIdGet?.toString() ?? 'Unknown'));
                          myHandler.MessageHandler.showAlertDialog(context, 'ID скопирован');
                        },
                        child: Text(
                          Anon.anonIdGet?.toString() ?? 'Unknown',
                          style: TextStyle(color: Colors.white.withOpacity(0.5)),
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text('Имя пользователя', style: TextStyle(color: Colors.white)),
                      subtitle: Text(_username, style: TextStyle(color: Colors.white.withOpacity(0.5))),
                      onTap: () {
                        _navigateToEditScreen('имя пользователя', _username, (newUsername) {
                          setState(() {
                            _username = newUsername;
                            changeProfileScreenVM.changeUsername(newUsername);
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProfileOptions(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    double offsetX = 10.0;
    double offsetY = 70.0;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay) + Offset(offsetX, offsetY),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay) + Offset(offsetX, offsetY),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.photo_camera, color: Colors.white),
            title: const Text('Добавить фотографию', style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pop(context);

              // Вызов метода выбора изображения
              final pickedImage = await FileUtils.pickImage();

              if (pickedImage != null) {
                setState(() {
                  _profileImagePath = pickedImage.path;
                });
                _saveProfile();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Изображение не выбрано',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Color(0xFF222222),
                  ),
                );
              }
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.delete, color: Colors.white),
            title: const Text('Удалить фотографию', style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pop(context);
              setState(() {
                _profileImagePath = null;
              });
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('profileImagePath');
            },
          ),
        ),
      ],
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
    );
  }
}
