import '../../../data/todo/todo_data.dart';
import '../../core/base_api_service.dart';
import '../http_native.dart';

/// HTTP implementation of [TodoApiMixin].
///
/// Uses [HttpNative] for raw REST API calls.
mixin HttpTodoRepo on BaseApiService {
  HttpNative get native;

  @override
  Future<List<ToDoData>> getTodos(String userId) async {
    try {
      final res = await native.get(
        '/todos',
        queryParameters: {'userId': userId},
      );
      final list = res.data as List;
      return list.map((json) => ToDoData.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ToDoData> addTodo(ToDoData todo) async {
    await native.post('/todos', data: todo.toJson());
    return todo;
  }

  @override
  Future<void> updateTodo(ToDoData todo) async {
    await native.put('/todos/${todo.id}', data: todo.toJson());
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    await native.delete('/todos/$todoId');
  }
}
