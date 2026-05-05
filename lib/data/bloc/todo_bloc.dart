import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/providers.dart';
import '../data/todo/todo_data.dart';
import 'auth_bloc.dart';

final todoBlocProvider = AsyncNotifierProvider<TodoBloc, List<ToDoData>>(
  TodoBloc.new,
);

class TodoBloc extends AsyncNotifier<List<ToDoData>> {
  @override
  Future<List<ToDoData>> build() async {
    // Watch authBloc to refetch when user changes
    final authState = ref.watch(authBlocProvider);
    final user = authState.valueOrNull;

    if (user == null) {
      return [];
    }

    if (user.isGuest) {
      final storage = ref.watch(localStorageProvider);
      final cached = storage.getCachedJsonList('guest_todos');
      if (cached != null) {
        return cached.map((e) => ToDoData.fromJson(e)).toList();
      }
      return [];
    }

    final api = ref.watch(apiServiceProvider);
    return api.getTodos(user.id);
  }

  /// Manually update the state cache (optimistic update)
  void addLocally(ToDoData todo) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([todo, ...current]);
  }

  void updateLocally(ToDoData updatedTodo) {
    final current = state.valueOrNull ?? [];
    final newList = current
        .map((t) => t.id == updatedTodo.id ? updatedTodo : t)
        .toList();
    state = AsyncData(newList);
  }

  void deleteLocally(String id) {
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.where((t) => t.id != id).toList());
  }
}
