import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_item.dart';
import '../screens/add_todo_screen.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoItem todoItem;
  final Function(TodoItem) onUpdate;


  const TodoItemWidget({super.key, required this.todoItem, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ()async{
        final newTodo = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  AddTodoScreen( todoItem: todoItem,)),
        );
        if (newTodo != null && (newTodo.title.isNotEmpty || newTodo.description.isNotEmpty)) {
          onUpdate(newTodo);
        }
      },
      title: Text(todoItem.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 21),overflow: TextOverflow.ellipsis,maxLines: 2,),
      subtitle: Text(todoItem.description,overflow: TextOverflow.ellipsis,maxLines: 2,),
    );
  }
}
