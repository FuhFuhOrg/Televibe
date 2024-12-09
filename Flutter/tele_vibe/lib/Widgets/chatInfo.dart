import 'package:flutter/material.dart';
import 'profileScreen.dart'; // Экран профиля
import 'renameScreen.dart'; // Экран переименования
import 'permissionsScreen.dart'; // Экран изменения разрешений
import 'addParticipantScreen.dart';
import 'renameTextField.dart';
import 'UnderWidgets/fileUtils.dart';

class ChatInfo extends StatefulWidget {
  const ChatInfo({super.key, required this.initialGroupName});

  final String initialGroupName;

  @override
  _ChatInfoState createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo>{
  late String _groupName;

  @override
  void initState() {
    super.initState();
    // Инициализация поля _groupName значением из конструктора
    _groupName = widget.initialGroupName;
  }

  // Метод для перехода на экран изменения текста
  void _navigateToEditScreen(BuildContext context, String title, String currentText, Function(String) onSave) async {
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
      backgroundColor: const Color(0xFF052018),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: const Color(0xFF3E505F),
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
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Название группы',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '5 участников',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
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
                  _navigateToEditScreen(context, 'название группы', _groupName, (newName) {
                    setState(() {
                      _groupName = newName;
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
                // Кнопка "Добавить участника"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => AddParticipantScreen(),
                      );
                      // Логика добавления участников
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF021510),
                    ),
                    child: const Text('Добавить участников', style: TextStyle(color: Colors.white),),
                  ),
                ),
                // Перечень участников группы
                Padding(
                  padding: const EdgeInsets.only(top: 8.0), // Уменьшен отступ
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5, // Количество участников группы
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                  nickname: 'Никнейм ${index + 1}'),
                            ),
                          );
                        },
                        onLongPress: () {
                          _showParticipantOptions(context, index);
                        },
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                            ), // Укажите URL фотографии участника
                          ),
                          title: Text('Никнейм ${index + 1}', style: const TextStyle(color: Colors.white)),
                          subtitle: const Text('Описание участника', style: TextStyle(color: Colors.white)),
                          trailing: Text(
                            _getUserRole(index),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getUserRole(int index) {
    switch (index) {
      case 0:
        return 'Владелец';
      case 1:
        return 'Админ';
      default:
        return 'Участник';
    }
  }

  void _showParticipantOptions(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Опции участника',
            style: TextStyle(color: Colors.white), 
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text(
                  'Переименовать',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RenameScreen(
                          nickname: 'Никнейм ${index + 1}'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.white),
                title: const Text(
                  'Удалить',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Логика удаления участника
                },
              ),
              ListTile(
                leading: const Icon(Icons.security, color: Colors.white),
                title: const Text(
                  'Изменить разрешения',
                  style: TextStyle(color: Colors.white), 
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PermissionsScreen(
                          nickname: 'Никнейм ${index + 1}'),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.white), 
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class BottomSheetMenu extends StatelessWidget {
  const BottomSheetMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Поиск участников'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Удалить группу'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Покинуть группу'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

void _showProfileOptions(BuildContext context) {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  String? _profileImagePath;

  double offsetX = 10.0;
  double offsetY = 70.0; // Смещение по вертикали

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
          title: const Text('Изменить фото группы', style: TextStyle(color: Colors.white)),
          onTap: () async {
            Navigator.pop(context); // Закрываем меню

            final pickedImage = await FileUtils.pickImage();

            if (pickedImage != null) {
              // Сохраняем путь к изображению (например, в локальную переменную или через другой метод)
              _updateProfileImagePath(pickedImage.path, _profileImagePath);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Изображение не выбрано')),
              );
            }
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.delete, color: Colors.white),
          title: const Text('Удалить группу', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context); // Закрываем меню
            // Логика для удаления группы
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.mood_bad_rounded, color: Colors.white),
          title: const Text('Покинуть группу', style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pop(context); // Закрываем меню
            // Логика для покидания группы
          },
        ),
      ),
    ],
    color: Colors.black, // Фон меню
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Округлённые края
    ),
  );
}

// Метод для обновления пути к изображению
void _updateProfileImagePath(String newPath, String? _profileImagePath) {
  // Можно обновить переменную или использовать какой-то другой механизм
  _profileImagePath = newPath;
  // Обновление интерфейса, если требуется, например, через отдельный виджет или обновление списка
}
