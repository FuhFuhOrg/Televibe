import 'package:flutter/material.dart';
import 'profileScreen.dart'; // Экран профиля
import 'renameScreen.dart'; // Экран переименования
import 'permissionsScreen.dart'; // Экран изменения разрешений

class ChatInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8DA18B),
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
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Text(
                            'Название группы',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '5 участников',
                            style: TextStyle(
                              color: Colors.white,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditGroupNameScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => BottomSheetMenu(),
                  );
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                // Кнопка "Добавить участников"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Логика добавления участников
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E505F),
                    ),
                    child: const Text('Добавить участников'),
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
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png',
                            ), // Укажите URL фотографии участника
                          ),
                          title: Text('Никнейм ${index + 1}'),
                          subtitle: Text('Описание участника'),
                          trailing: Text(
                            _getUserRole(index),
                            style: TextStyle(
                              color: Colors.grey[700],
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
    // Пример логики для назначения роли
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
          title: const Text('Опции участника'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Переименовать'),
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
                leading: const Icon(Icons.delete),
                title: const Text('Удалить'),
                onTap: () {
                  Navigator.pop(context);
                  // Логика удаления участника
                },
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Изменить разрешения'),
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
              child: const Text('Отмена'),
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
  @override
  Widget build(BuildContext context) {
    return Container(
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

class EditGroupNameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8DA18B),
      appBar: AppBar(
        title: const Text('Редактировать название группы'),
        backgroundColor: const Color(0xFF3E505F),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Логика сохранения нового названия группы
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Название группы',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
