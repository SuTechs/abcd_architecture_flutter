import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:abcd_architecture_flutter/data/api/providers.dart';
import 'package:abcd_architecture_flutter/data/api/mock/mock_service.dart';
import 'package:abcd_architecture_flutter/data/command/base_command.dart';
import 'package:abcd_architecture_flutter/data/command/todo/todo_command.dart';
import 'package:abcd_architecture_flutter/data/bloc/auth_bloc.dart';
import 'package:abcd_architecture_flutter/data/bloc/todo_bloc.dart';

import 'helpers/memory_local_storage_service.dart';

void main() {
  test('TodoCommand CRUD flow', () async {
    // Setup
    final storage = MemoryLocalStorageService();
    await storage.init();

    final mockApi = MockService();
    mockApi.setStorage(storage);
    await mockApi.init();

    // Simulate logged in user
    final verificationId = await mockApi.sendOtp(
      destination: 'test@example.com',
      isEmail: true,
    );
    await mockApi.verifyOtp(otp: '123456', verificationId: verificationId!);

    final container = ProviderContainer(
      overrides: [
        apiServiceProvider.overrideWithValue(mockApi),
        localStorageProvider.overrideWithValue(storage),
      ],
    );
    addTearDown(container.dispose);

    BaseCommand.init(container);
    final todoCommand = TodoCommand();

    // Resolve auth first so userBloc does not fall back to guest state.
    await container.read(authBlocProvider.future);
    await container.read(todoBlocProvider.future);

    // Add Todo
    await todoCommand.addTodo('Buy milk', '2% please');

    // Check API state
    final apiTodos = await mockApi.getTodos(mockApi.currentUserId!);
    expect(apiTodos.length, 1);
    expect(apiTodos.first.title, 'Buy milk');

    // Check Bloc state (should be optimistically updated)
    final blocTodos = container.read(todoBlocProvider).value ?? [];
    expect(blocTodos.length, 1);
    expect(blocTodos.first.title, 'Buy milk');
    expect(blocTodos.first.isCompleted, isFalse);

    // Toggle Todo
    await todoCommand.toggleTodo(blocTodos.first);

    final updatedBlocTodos = container.read(todoBlocProvider).value ?? [];
    expect(updatedBlocTodos.first.isCompleted, isTrue);

    // Delete Todo
    await todoCommand.deleteTodo(updatedBlocTodos.first.id);

    final finalBlocTodos = container.read(todoBlocProvider).value ?? [];
    expect(finalBlocTodos, isEmpty);
  });
}
