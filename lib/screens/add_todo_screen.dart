import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class AddTodoScreen extends StatefulWidget {

  final TodoItem todoItem;
  const AddTodoScreen({super.key, required this.todoItem});

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.todoItem.title);
    _descriptionController = TextEditingController(text: widget.todoItem.description);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,), // Replace with your desired icon
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back when pressed
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
              decoration: const InputDecoration(hintText: 'Title',
                  hintStyle: TextStyle(fontSize: 21,
                      fontWeight: FontWeight.bold),
                border: InputBorder.none
              ),
              maxLines: null,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'Description',
                  border: InputBorder.none),
              maxLines: null,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              Navigator.pop(
                context,
                TodoItem(
                  title: _titleController.text,
                  description: _descriptionController.text,
                ),
              );

            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.save_as_outlined,color: Colors.white,),
                Text('Save',style: TextStyle(color: Colors.white,fontSize: 11),)
              ],
            ),
          ),
          SizedBox(width: 10,),
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.cancel,color: Colors.white,),
                Text('Cancel',style: TextStyle(color: Colors.white,fontSize: 11),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
