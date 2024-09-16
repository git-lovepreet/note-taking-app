import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo_item.dart';
import '../widgets/todo_item_widget.dart';
import 'add_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TodoItem> _todos = [TodoItem(title: 'Add', description: 'Click "+" to add Task.'),
    TodoItem(title: 'Edit', description: 'Click on Item to Edit.'),
    TodoItem(title: 'Delete', description: 'Slide left to Delete'),];
  List<TodoItem> _filteredTodos = [TodoItem(title: 'Add', description: 'Click "+" to add Task.'),
    TodoItem(title: 'Edit', description: 'Click on Item to Edit.'),
    TodoItem(title: 'Delete', description: 'Slide left to Delete'),];



  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList('todos');
    if (items != null) {
      setState(() {
        _todos = items.map((item) => TodoItem.fromJson(item)).toList();
        _filteredTodos = _todos;
      });
    }
  }

  void _addTodoItem(TodoItem item) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _todos.add(item);
      _filteredTodos = _todos;
      prefs.setStringList('todos', _todos.map((item) => item.toJson()).toList());
    });
  }

  void _updateTodoItem(TodoItem newTodo, int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _todos[index] = newTodo;
      _filteredTodos = _todos;
      prefs.setStringList('todos', _todos.map((item) => item.toJson()).toList());
    });
  }

  void _deleteTodoItem( int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _todos.removeAt(index);
      _filteredTodos = _todos;
      prefs.setStringList('todos', _todos.map((item) => item.toJson()).toList());
    });
  }

  void _filterTodos(String query) {
    setState(() {
      _filteredTodos = _todos.where((item) {
        return item.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.sticky_note_2_rounded,size: 36,),
            SizedBox(
              width: 5,
            ),
            Text('Notes',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 36),),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child:
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search,size: 26,color: Colors.black,),
                hintText: 'Search',
                hintStyle: TextStyle(fontSize: 16),
                filled: true,
                fillColor: Colors.grey.shade300,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(34),
                  borderSide: BorderSide.none
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(34),
                    borderSide: BorderSide.none
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 4.0),
              ),
              onChanged: _filterTodos,
                        ),
            ),
            Divider(thickness: 1,color: Colors.grey.shade400,),
            Expanded(
              child: ListView.separated(
                itemCount: _filteredTodos.length,
                itemBuilder: (context, index) {
                  return Slidable(
                                            endActionPane: ActionPane(

                                              motion: StretchMotion(),
                                              children: [
                                                SlidableAction(onPressed: (context){
                                                  setState(() {
                                                    _deleteTodoItem(index);
                                                  });
                                                },
                                                  icon: Icons.delete,

                                                  backgroundColor: Colors.black,
                                                  borderRadius: BorderRadius.circular(15),),


                                              ],
                                            ),
                                        child: TodoItemWidget(todoItem: _filteredTodos[index],
                                        onUpdate: (newTodo) =>_updateTodoItem(newTodo, index),));
                }, separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                );
              },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          final newTodo = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  AddTodoScreen(todoItem: TodoItem(title: "",description: ""))),
          );
          if (newTodo != null && (newTodo.title.isNotEmpty || newTodo.description.isNotEmpty)) {
            _addTodoItem(newTodo);
          }
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}