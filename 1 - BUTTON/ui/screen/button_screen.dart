import 'package:flutter/material.dart';

import '../../model/async.data.dart';
import '../../data/repository_exception.dart';
import '../../model/button_status.dart';
import '../../data/button_repository.dart';
import '../../widget/button_widget.dart';


class ButtonScreen extends StatefulWidget {
  const ButtonScreen({super.key});

  @override
  State<ButtonScreen> createState() => _ButtonScreenState();
}

class _ButtonScreenState extends State<ButtonScreen> {
  final _repository = ButtonStatusRepository();

  AsyncData<ButtonStatus> data = AsyncData.idle();

  @override
  void initState() {
    super.initState();
    // Fetch init state
    _fetchButtonData();
  }

  void _fetchButtonData() async {
    setState(() => data = AsyncData.loading());
    try {
      final status = await _repository.getButtonStatus();
      setState(() => data = AsyncData.success(status));
    } on RepositoryException catch (e) {
      setState(() => data = AsyncData.error(e.message));
    }
  }

  Future<void> _onButtonTap() async {
    final current = data.data;
    if (current == null) return;

    final newSelected = !current.selected;
    // Optimistic UI update.
    setState(
      () => data = AsyncData.success(current.copyWith(selected: newSelected)),
    );

    try {
      await _repository.updateSelected(newSelected);
    } on RepositoryException catch (e) {
      // Roll back on failure and surface the error.
      setState(() => data = AsyncData.error(e.message));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EX1 - Button status')),
      body: Center(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (data.isLoading) {
      return const CircularProgressIndicator();
    }
    if (data.hasError) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchButtonData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    final status = data.data!;
    return ButtonWidget(
      title: status.title,
      selected: status.selected,
      onTap: _onButtonTap,
    );
  }
}
