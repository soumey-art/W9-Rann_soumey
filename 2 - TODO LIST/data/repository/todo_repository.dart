import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/todo.dart';
import '../dto/todo_dto.dart';
import 'repository_exception.dart';

class TodoRepository {
  static final global = TodoRepository(); // unique instance

  static const String _baseUrl =
      'https://w9-ex2-default-rtdb.asia-southeast1.firebasedatabase.app';

  static const String _node = 'todos';

  Future<List<Todo>> getTodos() async {
    // Fetch todos from Firebase

    final uri = Uri.parse('$_baseUrl/$_node.json');

    try {
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw RepositoryException("Firebase error: ${response.statusCode}");
      }

      if (response.body == 'null') {
        return [];
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      List<Todo> todos = [];

      data.forEach((id, value) {
        todos.add(TodoDto.fromJson(id, value));
      });

      return todos;
    } catch (e) {
      throw RepositoryException("No internet connection. Please try again.");
    }
  }

  Future<void> updateCompleted(String todoId, bool completed) async {

    final uri = Uri.parse('$_baseUrl/$_node/$todoId.json');

    try {
      final response = await http.patch(
        uri,
        body: jsonEncode({TodoDto.completed: completed}),
      );

      if (response.statusCode != 200) {
        throw RepositoryException("Failed to update todo");
      }
    } catch (e) {
      throw RepositoryException("No internet connection. Please try again.");
    }
  }
}
