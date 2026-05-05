import 'package:uuid/uuid.dart';

import '../../api/providers.dart';
import '../../bloc/todo_bloc.dart';
import '../../bloc/user_bloc.dart';
import '../../data/todo/todo_data.dart';
import '../base_command.dart';

class TodoCommand extends BaseCommand {
  static const _uuid = Uuid();

  /// Maximum number of active (non-completed) todos for free users.
  static const int freeTaskLimit = 3;

  /// Returns the number of active (non-completed) todos.
  int get activeTaskCount {
    final todos = ref.read(todoBlocProvider).value ?? [];
    return todos.where((t) => !t.isCompleted).length;
  }

  /// Whether the user can add a todo for free (premium or under limit).
  bool canAddTodoForFree() {
    final user = ref.read(userBlocProvider);
    if (user.isPremium) return true;
    return activeTaskCount < freeTaskLimit;
  }

  /// How many free task slots remain.
  int get remainingFreeSlots {
    final user = ref.read(userBlocProvider);
    if (user.isPremium) return -1; // Unlimited
    return (freeTaskLimit - activeTaskCount).clamp(0, freeTaskLimit);
  }

  Future<void> _saveGuestTodosLocally() async {
    final currentTodos = ref.read(todoBlocProvider).value ?? [];
    await ref
        .read(localStorageProvider)
        .cacheJsonList(
          'guest_todos',
          currentTodos.map((e) => e.toJson()).toList(),
        );
  }

  Future<void> addTodo(String title, String description) async {
    final user = ref.read(userBlocProvider);

    final newTodo = ToDoData(
      id: _uuid.v4(),
      userId: user.id,
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );

    // Optimistic update
    todoBloc.addLocally(newTodo);

    if (user.isGuest) {
      await _saveGuestTodosLocally();
      return;
    }

    try {
      await api.addTodo(newTodo);
    } catch (e) {
      // Revert if failed
      ref.invalidate(todoBlocProvider);
    }
  }

  Future<void> toggleTodo(ToDoData todo) async {
    final updated = todo.copyWith(isCompleted: !todo.isCompleted);
    todoBloc.updateLocally(updated);

    final user = ref.read(userBlocProvider);
    if (user.isGuest) {
      await _saveGuestTodosLocally();
      return;
    }

    try {
      await api.updateTodo(updated);
    } catch (e) {
      ref.invalidate(todoBlocProvider);
    }
  }

  Future<void> updateTodo(ToDoData todo) async {
    todoBloc.updateLocally(todo);

    final user = ref.read(userBlocProvider);
    if (user.isGuest) {
      await _saveGuestTodosLocally();
      return;
    }

    try {
      await api.updateTodo(todo);
    } catch (e) {
      ref.invalidate(todoBlocProvider);
    }
  }

  Future<void> deleteTodo(String id) async {
    todoBloc.deleteLocally(id);

    final user = ref.read(userBlocProvider);
    if (user.isGuest) {
      await _saveGuestTodosLocally();
      return;
    }

    try {
      await api.deleteTodo(id);
    } catch (e) {
      ref.invalidate(todoBlocProvider);
    }
  }
}
