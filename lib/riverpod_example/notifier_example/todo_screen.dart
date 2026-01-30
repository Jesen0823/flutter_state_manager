import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'todo_provider.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);
    final todoNotifier = ref.read(todoProvider.notifier);
    final textController = TextEditingController();

    return Scaffold(
      appBar: _buildAppBar(todos, todoNotifier),
      body: Column(
        children: [
          // 添加 Todo 输入框
          _buildTodoInputSection(textController, todoNotifier),

          // Todo 列表
          Expanded(
            child: todos.isEmpty
                ? _buildEmptyState()
                : _buildTodoList(todos, todoNotifier),
          ),

          // 统计信息
          if (todos.isNotEmpty) _buildStatisticsSection(todos),
        ],
      ),
    );
  }

  // Build App Bar
  AppBar _buildAppBar(List todos, dynamic todoNotifier) {
    return AppBar(
      title: const Text('Todo 列表'),
      backgroundColor: Colors.blue,
      elevation: 0,
      actions: [
        if (todos.isNotEmpty)
          IconButton(
            onPressed: todoNotifier.clearTodos,
            icon: const Icon(Icons.delete_sweep),
            tooltip: '清空所有',
          ),
      ],
    );
  }

  // Build Todo Input Section
  Widget _buildTodoInputSection(
    TextEditingController textController,
    dynamic todoNotifier,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: '输入 Todo 内容',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  todoNotifier.addTodo(value.trim());
                  textController.clear();
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              final value = textController.text.trim();
              if (value.isNotEmpty) {
                todoNotifier.addTodo(value);
                textController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  // Build Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无 Todo',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 8),
          Text(
            '添加第一个 Todo 开始',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  // Build Todo List
  Widget _buildTodoList(List todos, dynamic todoNotifier) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return _buildTodoItem(todo, todoNotifier);
      },
    );
  }

  // Build Todo Item
  Widget _buildTodoItem(dynamic todo, dynamic todoNotifier) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      child: ListTile(
        leading: Checkbox(
          value: todo.completed,
          onChanged: (_) => todoNotifier.toggleTodo(todo.id),
          activeColor: Colors.blue,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: todo.completed ? Colors.grey.shade500 : Colors.black,
          ),
        ),
        trailing: IconButton(
          onPressed: () => todoNotifier.deleteTodo(todo.id),
          icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
          tooltip: '删除',
        ),
      ),
    );
  }

  // Build Statistics Section
  Widget _buildStatisticsSection(List todos) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '总计: ${todos.length}',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          Text(
            '已完成: ${todos.where((todo) => todo.completed).length}',
            style: TextStyle(fontSize: 14, color: Colors.green.shade600),
          ),
        ],
      ),
    );
  }
}
