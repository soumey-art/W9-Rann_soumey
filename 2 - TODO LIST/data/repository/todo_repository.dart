import 'dart:convert';
import 'package:http/http.dart' as http;


import '../../models/todo.dart';
import '../dto/todo_dto.dart';
import 'repository_exception.dart';

class TodoRepository {
  static final global = TodoRepository();   // unique instance
  

  //
  static const String _baseUrl =
    'https://w9-ex2-default-rtdb.asia-southeast1.firebasedatabase.app/todos';
  static const String _node = 'todos';

  Future<List<Todo>> getTodos() async {
    final uri = Uri.parse('$_baseUrl/$_node.json');

    late final http.Response response;
    try {
      response = await http.get(uri);
    } catch (_) {
       // Ensure the message is displayed on the UI if error occured
      //throw RepositoryException("No wifi !"); at all.
      throw RepositoryException(
        'No internet connection. Please check your network and try again.',
      );
    }
      if (response.statusCode != 200) {
      throw RepositoryException(
        'Firebase returned an error (status code ${response.statusCode})',
      );
    }

    if (response.body == 'null') {
      // No todos yet -> empty list, not an error.
      return [];
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return json.entries
          .map(
            (entry) => TodoDto.fromJson(
              entry.key,
              entry.value as Map<String, dynamic>,
            ),
          )
          .toList();
    } on RepositoryException {
      rethrow;
    } catch (_) {
      throw RepositoryException(
        'The data received from Firebase does not match the expected structure.',
      );
    }
  }

    Future<void> updateCompleted(String todoId, bool completed) async {
    final uri = Uri.parse('$_baseUrl/$_node/$todoId.json');

    late final http.Response response;
    try {
      response = await http.patch(
        uri,
        body: jsonEncode({TodoDto.completed: completed}),
      );
    } catch (_) {
      throw RepositoryException(
        'No internet connection. Please check your network and try again.',
      );
    }

    if (response.statusCode != 200) {
      throw RepositoryException(
        'Failed to update the todo (status code ${response.statusCode})',
      );
    }
  }
}
