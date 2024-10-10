import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<String> _todoList = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  Future<void> _loadToDoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoList = prefs.getStringList('todos') ?? [];
    });
  }

  Future<void> _saveTodoList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('todos', _todoList);
  }

  void _removeToDoItem(int index) {
    setState(() {
      _todoList.removeAt(index);
      _saveTodoList();
    });
  }

  void _showAddToDoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add to do Item'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'New Todo Item',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  setState(() {
                    _todoList.add(_textController.text);
                    _saveTodoList();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editTodoItem(int index) {
    _textController.text = _todoList[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit to do Item'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Edit Todo Item',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  setState(() {
                    _todoList[index] = _textController.text;
                    _saveTodoList();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ez-boss.jpg'), // Path ke gambar anjay.jpg
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Todo List',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '2',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/anjay.jpg'), // Path ke gambar ez-boss.jpg
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: _todoList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blueGrey.shade300,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              capitalize(_todoList[index]),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => _editTodoItem(index),
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () => _removeToDoItem(index),
                                  icon: const Icon(Icons.delete),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddToDoDialog,
        backgroundColor: Colors.pink,
        child: const Icon(
          Icons.add,
          size: 40,
          color: Colors.purple,
        ),
      ),
    );
  }
}
