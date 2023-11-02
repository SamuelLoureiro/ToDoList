import 'package:flutter/material.dart';
import 'package:todolist/core/modelos/todo_user.dart';
import 'package:todolist/core/services/auth_service.dart';
import 'package:todolist/core/services/auth_firebase_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<ToDoListPage> {
  final ToDoUser user = AuthFirebaseService().currentUser!;
  final _todoList = <Map<String, dynamic>>[];
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addTodo() {
    setState(() {
      _todoList.add({'text': _textController.text, 'checked': false});
      _textController.clear();
    });
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  Future<String> getImageUrl(String imagePath) async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child(imagePath);
    final url = await ref.getDownloadURL();
    return url;
  }

  void someFunction() async {
    String imagePath = 'path/to/your/image.jpg'; // replace with your image path
    String imageUrl = await getImageUrl(imagePath);
    // Now you can use imageUrl in your code, for example:
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(user.name),
              accountEmail: Text(user.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(user.imageURL),
              ),
            ),
            ListTile(
              title: TextButton(
                onPressed: () => AuthService().logout(),
                child: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_todoList[index]['text']),
            onDismissed: (direction) {
              setState(() {
                _todoList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Item deleted")),
              );
            },
            background: Container(color: Colors.red),
            child: CheckboxListTile(
              title: Text(
                _todoList[index]['text'],
                style: TextStyle(
                  decoration: _todoList[index]['checked']
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              value: _todoList[index]['checked'],
              onChanged: (bool? value) {
                setState(() {
                  _todoList[index]['checked'] = value;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Add a new todo',
                  ),
                  onSubmitted: (value) {
                    _addTodo();
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
