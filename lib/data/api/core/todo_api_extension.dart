import '../../data/todo/todo_data.dart';

/// Feature mixin: Todo API operations.
///
/// Added to [BaseApiService] via `with TodoApiMixin`.
/// Every backend (Firebase, Supabase, HTTP, Mock) must implement these.
mixin TodoApiMixin {
  Future<List<ToDoData>> getTodos(String userId);
  Future<ToDoData> addTodo(ToDoData todo);
  Future<void> updateTodo(ToDoData todo);
  Future<void> deleteTodo(String todoId);
}
