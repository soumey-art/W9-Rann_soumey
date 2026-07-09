import 'package:flutter/material.dart';

import '../../../data/repository/repository_exception.dart';

import '../../../data/repository/todo_repository.dart';
import '../../../models/todo.dart';
import '../../theme/app_screen.dart';
import '../../utils/async_data.dart';
import 'todo_card.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  AsyncData<List<Todo>> asyncData = AsyncData.notstarted();

  @override
  void initState() {
    super.initState();

    // Fetch todos on init state
    _fetchTodos();
  }

  void _fetchTodos() async {
    TodoRepository repository = TodoRepository.global;

    setState(() => asyncData = AsyncData.loading());

    try {
      List<Todo> todos = await repository.getTodos();
      setState(() => asyncData = AsyncData.success(todos));
    } on RepositoryException catch (e) {
      setState(() => asyncData = AsyncData.error(e.message));
    }
  }

  void onUpdateCompleted(Todo todo) async {
    TodoRepository repository = TodoRepository.global;

    // We don't reload the full list: we update the modified Todo directly
    // in the cache (asyncData) so the UI feels instant.
    final currentTodos = asyncData.value;
    if (currentTodos == null) return;

    final newCompleted = !todo.completed;
    final updatedTodo = todo.copyWith(newCompleted);

    // Optimistic update.
    final optimisticTodos = [
      for (final t in currentTodos) t.id == todo.id ? updatedTodo : t,
    ];
    setState(() => asyncData = AsyncData.success(optimisticTodos));

    try {
      await repository.updateCompleted(todo.id, newCompleted);
    } on RepositoryException catch (e) {
      // Roll back the optimistic change and surface the error.
      setState(() => asyncData = AsyncData.success(currentTodos));
      _showErrorSnackBar(e.message);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget get content => switch (asyncData.status) {
    AsyncStatus.notstarted => GestureDetector(
      onTap: _fetchTodos,
      child: Text(
        "Tap to refresh",
        style: AppTheme.paragraph.copyWith(color: AppTheme.redColor),
      ),
    ),

    AsyncStatus.loading => CircularProgressIndicator(),

    AsyncStatus.success => _buildTodos(),

    AsyncStatus.error => _buildError(),
  };

  Widget _buildTodos() {
    List<Todo> todos = asyncData.value!;
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) =>
          TodoCard(todo: todos[index], onTap: onUpdateCompleted),
    );
  }

  Widget _buildError() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.warning, color: AppTheme.redColor),
        SizedBox(width: 10),

        Text(
          asyncData.error!,
          style: AppTheme.paragraph.copyWith(color: AppTheme.redColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        title: Text("Welcome !", style: AppTheme.heading),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: content),
      ),
    );
  }
}
