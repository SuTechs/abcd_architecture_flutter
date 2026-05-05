import '../../../data/todo/todo_data.dart';
import '../../core/base_api_service.dart';
import '../supabase_native.dart';

/// Supabase implementation of [TodoApiMixin].
///
/// Uses [SupabaseNative] for raw database operations.
mixin SupabaseTodoRepo on BaseApiService {
  SupabaseNative get native;

  @override
  Future<List<ToDoData>> getTodos(String userId) async {
    final list = await native.selectWhere('todos', 'userId', userId);
    return list.map((json) => ToDoData.fromJson(json)).toList();
  }

  @override
  Future<ToDoData> addTodo(ToDoData todo) async {
    await native.insert('todos', todo.toJson());
    return todo;
  }

  @override
  Future<void> updateTodo(ToDoData todo) async {
    await native.upsert('todos', todo.toJson());
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    await native.delete('todos', todoId);
  }
}
