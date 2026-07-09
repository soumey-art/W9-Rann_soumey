
import '../../models/todo.dart';

class TodoDto {
  static const id = "id";
  static const title = "title";
  static const completed = "completed";

  static Todo fromJson(String id, Map<String, dynamic> json) {
    // Assert the map contains the keys  title and completed with the right data types
    if (!json.containsKey(title) ||
        !json.containsKey(completed) ||
        json[title] is! String ||
        json[completed] is! bool) {
      throw FormatException(
        'Firebase todo data does not contain the expected keys/types '
        '(title: String, completed: bool)',
      );
    }

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
