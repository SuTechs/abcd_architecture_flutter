import 'package:flutter_test/flutter_test.dart';
import 'package:abcd_architecture_flutter/data/api/mock/mock_service.dart';
import 'package:abcd_architecture_flutter/data/data/todo/todo_data.dart';

void main() {
  late MockService api;

  setUp(() async {
    api = MockService();
    await api.init();
  });

  group('MockService Auth', () {
    test('sendOtp and verifyOtp works', () async {
      final verificationId = await api.sendOtp(
        destination: 'test@example.com',
        isEmail: true,
      );
      expect(verificationId, isNotNull);

      final userId = await api.verifyOtp(
        otp: '123456',
        verificationId: verificationId!,
      );
      expect(userId, isNotNull);
      expect(api.isSignedIn, isTrue);
      expect(api.currentUserId, userId);
    });

    test('signOut clears state', () async {
      final verificationId = await api.sendOtp(
        destination: 'test@example.com',
        isEmail: true,
      );
      await api.verifyOtp(otp: '123456', verificationId: verificationId!);

      expect(api.isSignedIn, isTrue);
      await api.signOut();
      expect(api.isSignedIn, isFalse);
      expect(api.currentUserId, isNull);
    });
  });

  group('MockService Todos', () {
    test('CRUD operations', () async {
      final todo = ToDoData(
        id: '1',
        userId: 'user1',
        title: 'Test',
        description: '',
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      // Create
      await api.addTodo(todo);
      var todos = await api.getTodos('user1');
      expect(todos.length, 1);
      expect(todos.first.title, 'Test');

      // Update
      final updated = todo.copyWith(title: 'Updated', isCompleted: true);
      await api.updateTodo(updated);
      todos = await api.getTodos('user1');
      expect(todos.first.title, 'Updated');
      expect(todos.first.isCompleted, isTrue);

      // Delete
      await api.deleteTodo('1');
      todos = await api.getTodos('user1');
      expect(todos, isEmpty);
    });
  });
}
