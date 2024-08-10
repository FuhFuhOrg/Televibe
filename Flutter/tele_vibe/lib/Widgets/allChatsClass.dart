import 'package:flutter/material.dart';
import 'package:tele_vibe/ViewModel/AllChatsVM.dart';
import 'package:tele_vibe/Widgets/chatList.dart';


class AllChatsPage extends StatefulWidget {
  @override
  _AllChatsClassState createState() => _AllChatsClassState();
}

class _AllChatsClassState extends State<AllChatsPage>{
  final List<String> entries = <String>['ff', 'gg', 'hh', 'ff', 'gg', 'hh', 'ff', 'gg', 'hh', 'ff', 'gg', 'hh'];
  final AllChatsVM _allChatsVM = AllChatsVM();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Televibe"),
              Padding(
                padding: EdgeInsets.all(0),
                child: Icon(
                  Icons.search, color: Colors.black, size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: entries.isNotEmpty
      ? ListView.builder(
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () => _allChatsVM.navigateToChatList(context),
              leading: const CircleAvatar(
                backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/a/a8/Sample_Network.jpg'),
              ),
              tileColor: Colors.grey,
              textColor: Colors.black,
              title: Text('Item ${entries[index]}'), // Название чата
              subtitle: Text('Item ${entries[index]}'), // Сообщение
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 32), // Отступ сверху
                  Text('Item ${entries[index]}'), // Время
                ],
              ),
            );
          },
        )
      : const Center(child: Text('You don`t have chats(')),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        currentIndex: 1,
      ),
    );
  }
}