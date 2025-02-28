import 'package:flutter/material.dart';
import 'renameTextField.dart';
import 'package:flutter/services.dart';
import 'UnderWidgets/fileUtils.dart';
import 'package:tele_vibe/ViewModel/otherManVM.dart';
import 'package:tele_vibe/GettedData/MessageHandler.dart' as myHandler;

class ProfileScreenOther extends StatefulWidget {
  final String nickname;
  final int userID;

  const ProfileScreenOther({super.key, required this.nickname, required this.userID});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreenOther> {
  String _nickname;
  String _phoneNumber = 'Введите номер телефона';
  String _username = 'Введите имя пользователя';
  String _about = 'О себе';
  String? _profileImagePath;
  final otherManVM _chatListVM = otherManVM();
  
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
                ListTile( // Если что, уберем
                  title: const Text(
                    'ID пользователя',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(ClipboardData(text: _chatListVM.getUserId().toString()));
                      myHandler.MessageHandler.showAlertDialog(context, 'ID скопирован');
                    },
                    child: Text(
                      _chatListVM.getUserId().toString(),
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Номер телефона', style: TextStyle(color: Colors.white)),
                  subtitle: Text(_chatListVM.getTelephoneNumber(), style: TextStyle(color: Colors.white.withOpacity(0.5))),
                ),
                ListTile(
                  title: const Text('Имя пользователя', style: TextStyle(color: Colors.white)),
                  subtitle: Text(_chatListVM.getUsername(), style: TextStyle(color: Colors.white.withOpacity(0.5))),
                ),
                ListTile(
                  title: const Text('О себе', style: TextStyle(color: Colors.white)),
                  subtitle: Text(_chatListVM.getInfoAboutMe(), style: TextStyle(color: Colors.white.withOpacity(0.5))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
