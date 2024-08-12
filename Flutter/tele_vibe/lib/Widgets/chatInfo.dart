import 'package:flutter/material.dart';

class ChatInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8DA18B),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFF3E505F),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditGroupNameScreen()),
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
      body: Column(
        children: <Widget>[
          // Верхняя часть экрана с фотографией и названием группы
          Container(
            height: MediaQuery.of(context).size.height * 3 / 7,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/group_photo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Название группы',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '5 участников',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Кнопка "Добавить участников"
          Padding(
            padding: const EdgeInsets.all(16.0),
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
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Количество участников группы
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Участник ${index + 1}'),
                  // Можете добавить другие элементы списка участников
                );
              },
            ),
          ),
        ],
      ),
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
            leading: Icon(Icons.search),
            title: Text('Поиск участников'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Удалить группу'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Покинуть группу'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
