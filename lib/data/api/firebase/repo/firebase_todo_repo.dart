import '../../../data/todo/todo_data.dart';
import '../../core/base_api_service.dart';
import '../firebase_native.dart';

/// Firebase implementation of [TodoApiMixin].
///
/// Uses [FirebaseNative] for raw Firestore operations.
mixin FirebaseTodoRepo on BaseApiService {
  FirebaseNative get native;

  @override
  Future<List<ToDoData>> getTodos(String userId) async {
    final snapshot = await native.getCollectionWhere('todos', 'userId', userId);
    return snapshot.docs
        .map((d) => ToDoData.fromJson(d.data() as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ToDoData> addTodo(ToDoData todo) async {
    await native.setDoc('todos', todo.id, todo.toJson());
    return todo;
  }

  @override
  Future<void> updateTodo(ToDoData todo) async {
    await native.setDoc('todos', todo.id, todo.toJson());
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    await native.deleteDoc('todos', todoId);
  }
}
