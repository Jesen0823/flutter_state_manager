
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Todo 模型
class Todo {
  final String id;
  final String title;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
  });

  Todo copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}

// Todo 状态管理
class TodoNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() {
    // 初始状态
    return [];
  }

  // 添加 Todo
  void addTodo(String title) {
    final newTodo = Todo(
      id: DateTime.now().toString(),
      title: title,
    );
    state = [...state, newTodo];
  }

  // 切换 Todo 完成状态
  void toggleTodo(String id) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();
  }

  // 删除 Todo
  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  // 清空所有 Todo
  void clearTodos() {
    state = [];
  }
}

// 创建 Todo Provider
final todoProvider = NotifierProvider<TodoNotifier, List<Todo>>(
  TodoNotifier.new,
);
