import 'package:flutter/material.dart';
import 'renameTextField.dart';
import 'fileUtils.dart';

class ProfileScreen extends StatefulWidget {
  final String nickname;

  const ProfileScreen({super.key, required this.nickname});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nickname;
  String _phoneNumber = 'Введите номер телефона';
  String _username = 'Введите имя пользователя';
  String _about = 'О себе';
  String? _profileImagePath;

  _ProfileScreenState() : _nickname = '';

  @override
  void initState() {
    super.initState();
    _nickname = widget.nickname;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021510),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF021510),
            expandedHeight: MediaQuery.of(context).size.height * 3 / 7,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/a/a8/Sample_Network.jpg',
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _nickname,
                        style: const TextStyle(
                          color: Colors.white,
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
                icon: const Icon(Icons.edit),
                onPressed: () {
                  _navigateToEditScreen('никнейм', _nickname, (newName) {
                    setState(() {
                      _nickname = newName;
                    });
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
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
                  title: const Text('Номер телефона', style: TextStyle(color: Colors.white)),
                  subtitle: Text(_phoneNumber),
                  onTap: () {
                    _navigateToEditScreen('номер телефона', _phoneNumber, (newPhoneNumber) {
                      setState(() {
                        _phoneNumber = newPhoneNumber;
                      });
                    });
                  },
                ),
                ListTile(
                  title: const Text('Имя пользователя', style: TextStyle(color: Colors.white)),
                  subtitle: Text(_username),
                  onTap: () {
                    _navigateToEditScreen('имя пользователя', _username, (newUsername) {
                      setState(() {
                        _username = newUsername;
                      });
                    });
                  },
                ),
                ListTile(
                  title: const Text('О себе', style: TextStyle(color: Colors.white)),
                  subtitle: Text(_about),
                  onTap: () {
                    _navigateToEditScreen('информацию о себе', _about, (newAbout) {
                      setState(() {
                        _about = newAbout;
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
  }

  void _showProfileOptions(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    double offsetX = 10.0;
    double offsetY = 70.0; 

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay) + Offset(offsetX, offsetY), // Смещение для верхнего левого угла
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay) + Offset(offsetX, offsetY), // Смещение для нижнего правого угла
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
          // Логика сохранения пути к изображению
          // Например, добавьте поле _profileImagePath
          _profileImagePath = pickedImage.path;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Изображение не выбрано')), // Если изображение не выбрано
        );
      }
    },
  ),
),

        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.delete, color: Colors.white),
            title: const Text('Удалить фотографию', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              // Логика удаления фотографии
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title: const Text('Изменить информацию о себе', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _navigateToEditScreen('информацию о себе', _about, (newAbout) {
                setState(() {
                  _about = newAbout;
                });
              });
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
