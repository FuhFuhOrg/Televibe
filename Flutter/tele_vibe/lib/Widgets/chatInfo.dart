import 'package:flutter/material.dart';
import 'package:tele_vibe/ViewModel/ChatInfoVM.dart';
import 'profileScreen.dart'; // Экран профиля
import 'package:tele_vibe/ViewModel/chatListVM.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart' as myHandler;
import 'package:tele_vibe/ViewModel/ChatInfoVM.dart';
import 'profileScreenOther.dart'; // Экран профиля
import 'package:tele_vibe/Data/chats.dart';
import 'addParticipantScreen.dart';
import 'renameTextField.dart';
import 'UnderWidgets/fileUtils.dart';
import 'package:flutter/services.dart';

class ChatInfo extends StatefulWidget {
  const ChatInfo({super.key, required this.initialGroupName});

  final String initialGroupName;

  @override
  _ChatInfoState createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo>{
  final ChatInfoVM _chatListVM = ChatInfoVM();
  late String _groupName;
  late int kUsers;
  late String _chatId;

  @override
  void initState() {
    super.initState();
    // Инициализация поля _groupName значением из конструктора
    _groupName = _chatListVM.getNameGroup();
    kUsers = _chatListVM.getCountUsers();
    _chatId = _chatListVM.getChatId();
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
      backgroundColor: const Color(0xFF141414),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.grey,
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
                        children: <Widget>[
                          Text(
                            _groupName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            kUsers == 1
                              ? "${kUsers.toString()} участник"
                              : kUsers >= 2 && kUsers <= 4
                                  ? "${kUsers.toString()} участника"
                                  : "${kUsers.toString()} участников",
                            style: const TextStyle(
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
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: () {
                  _navigateToEditScreen(context, 'название группы', _groupName, (newName) {
                    setState(() {
                      _groupName = newName;
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
                // Кнопка "Добавить участника"
                /*
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
                      backgroundColor: const Color(0xFF222222),
                    ),
                    child: const Text('Добавить участников', style: TextStyle(color: Colors.white),),
                  ),
                ),
                */

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 52.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _chatId));
                      myHandler.MessageHandler.showAlertDialog(context, 'Текст скопирован');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF222222),
                    ),
                    child: const Text("Скопировать ID чата", style: TextStyle(color: Colors.white)),
                  ),
                ),
                // Перечень участников группы
                Padding(
                  padding: const EdgeInsets.only(top: 8.0), // Уменьшен отступ
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: kUsers, // Количество участников группы
                    itemBuilder: (context, index) {
                      final subuser = _chatListVM.getSubusers()[index]; // Получаем подюзера из списка

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => subuser.userName == "YOU" // Ваще не надежно будто, но что поделать
                                ? ProfileScreen(nickname: subuser.userName)
                                : ProfileScreenOther(nickname: subuser.userName),
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
                          title: Text(
                            subuser.userName, // Выводим никнейм
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: const Text(
                            'Чурка',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }

                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

void _showProfileOptions(BuildContext context) {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  String? _profileImagePath;
  final ChatInfoVM _chatInfoVM = ChatInfoVM();

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
                  const SnackBar(
                    content: Text(
                      'Изображение не выбрано', 
                      style: TextStyle(color: Colors.white)
                    ),
                    backgroundColor: Color(0xFF222222)
                  ), // Если изображение не выбрано
                );
            }
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.delete, color: Colors.white),
          title: const Text('Удалить группу', style: TextStyle(color: Colors.white)),
          onTap: () async {
            Navigator.pop(context); // Закрываем меню

            bool isDeleted = await _chatInfoVM.deleteNowGroup(context);

            if (isDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Чат удалён',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Color(0xFF222222),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Не удалось удалить чат',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Color(0xFF222222),
                ),
              );
            }
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
