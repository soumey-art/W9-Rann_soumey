import '../../models/todo.dart';

class TodoDto {
  static const id = "id";
  static const title = "title";
  static const completed = "completed";

  static Todo fromJson(String id, Map<String, dynamic> json) {
    return Todo(
      id: id,
      title: json[title] as String,
      completed: json[completed] as bool,
    );
  }

  static Map<String, dynamic> toJson(Todo todo) {
    return {title: todo.title, completed: todo.completed};
  }
}
