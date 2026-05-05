import '../../../data/todo/todo_data.dart';
import '../../core/base_api_service.dart';

/// Mock implementation of [TodoApiMixin].
///
/// Uses in-memory maps with Hive persistence.
mixin MockTodoRepo on BaseApiService {
  Map<String, ToDoData> get todos;

  Future<void> persistTodos();

  @override
  Future<List<ToDoData>> getTodos(String userId) async {
    return todos.values.where((t) => t.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<ToDoData> addTodo(ToDoData todo) async {
    todos[todo.id] = todo;
    await persistTodos();
    return todo;
  }

  @override
  Future<void> updateTodo(ToDoData todo) async {
    todos[todo.id] = todo;
    await persistTodos();
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    todos.remove(todoId);
    await persistTodos();
  }
}
