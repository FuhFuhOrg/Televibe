import 'package:flutter/material.dart';


class chatListPage extends StatefulWidget {
  @override
  _chatListState createState() => _chatListState();
}

class _chatListState extends State<chatListPage>{
  final List<String> entries = <String>['ff', 'gg', 'hh', 'ff', 'gg', 'hh', 'ff', 'gg', 'hh', 'ff', 'gg', 'hh'];
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          title: const Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/a/a8/Sample_Network.jpg'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Item',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ), // Название чата
                    Text(
                      'Item',
                      style: TextStyle(
                        fontSize: 13, 
                      ),
                    ), // Кол-во участников
                  ],
                ),
              ),
              Icon(
                Icons.search,
                color: Colors.black,
                size: 20,
              ),
            ],
          ),
        ),
      ),

      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {

        }
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        height: 58.0,
        color: Colors.green,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                maxLines: null,
                autocorrect: true,
                enableSuggestions: true,
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Введите ваше сообщение... ',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                // Обработчик событий
                String message = _textController.text;
                _textController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}