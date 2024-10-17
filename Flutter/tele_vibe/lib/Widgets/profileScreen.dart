import 'package:flutter/material.dart';

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

  _ProfileScreenState() : _nickname = '';

  @override
  void initState() {
    super.initState();
    _nickname = widget.nickname;
  }

  void _showEditDialog(String title, String currentText, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Изменить $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Введите $title',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8DA18B),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,  // Убираем стрелку "Назад"
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
                  _showEditDialog('никнейм', _nickname, (newName) {
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Номер телефона'),
                  subtitle: Text(_phoneNumber),
                  onTap: () {
                    _showEditDialog('номер телефона', _phoneNumber, (newPhoneNumber) {
                      setState(() {
                        _phoneNumber = newPhoneNumber;
                      });
                    });
                  },
                ),
                ListTile(
                  title: const Text('Имя пользователя'),
                  subtitle: Text(_username),
                  onTap: () {
                    _showEditDialog('имя пользователя', _username, (newUsername) {
                      setState(() {
                        _username = newUsername;
                      });
                    });
                  },
                ),
                ListTile(
                  title: const Text('О себе'),
                  subtitle: Text(_about),
                  onTap: () {
                    _showEditDialog('информацию о себе', _about, (newAbout) {
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
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 200,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Добавить фотографию'),
              onTap: () {
                Navigator.pop(context);
                // Логика добавления фотографии
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Удалить фотографию'),
              onTap: () {
                Navigator.pop(context);
                // Логика удаления фотографии
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Изменить информацию о себе'),
              onTap: () {
                Navigator.pop(context);
                _showEditDialog('информацию о себе', _about, (newAbout) {
                  setState(() {
                    _about = newAbout;
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
