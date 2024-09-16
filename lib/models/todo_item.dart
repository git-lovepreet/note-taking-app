import 'dart:convert';

class TodoItem {
  String title;
  String description;

  TodoItem({required this.title, required this.description});

  factory TodoItem.fromJson(String json) {
    final data = jsonDecode(json);
    return TodoItem(
      title: data['title'],
      description: data['description'],
    );
  }

  String toJson() {
    final data = {
      'title': title,
      'description': description,
    };
    return jsonEncode(data);
  }
}
