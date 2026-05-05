import 'package:abcd_architecture_flutter/screens/todos/todo_list_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TodoListLayout', () {
    test('inserts banner ads after every 5 free todos', () {
      expect(_freeLayout(0), <String>[]);
      expect(_freeLayout(4), <String>['todo0', 'todo1', 'todo2', 'todo3']);
      expect(_freeLayout(5), <String>[
        'todo0',
        'todo1',
        'todo2',
        'todo3',
        'todo4',
        'ad',
      ]);
      expect(_freeLayout(6), <String>[
        'todo0',
        'todo1',
        'todo2',
        'todo3',
        'todo4',
        'ad',
        'todo5',
      ]);
      expect(_freeLayout(10), <String>[
        'todo0',
        'todo1',
        'todo2',
        'todo3',
        'todo4',
        'ad',
        'todo5',
        'todo6',
        'todo7',
        'todo8',
        'todo9',
        'ad',
      ]);
      expect(_freeLayout(11), <String>[
        'todo0',
        'todo1',
        'todo2',
        'todo3',
        'todo4',
        'ad',
        'todo5',
        'todo6',
        'todo7',
        'todo8',
        'todo9',
        'ad',
        'todo10',
      ]);
    });

    test('does not insert banner ads for premium users', () {
      for (final todoCount in [0, 4, 5, 6, 10, 11]) {
        expect(
          _premiumLayout(todoCount),
          List.generate(todoCount, (index) => 'todo$index'),
        );
      }
    });
  });
}

List<String> _freeLayout(int todoCount) {
  return _layout(todoCount: todoCount, isPremium: false);
}

List<String> _premiumLayout(int todoCount) {
  return _layout(todoCount: todoCount, isPremium: true);
}

List<String> _layout({required int todoCount, required bool isPremium}) {
  final itemCount = TodoListLayout.itemCount(
    todoCount: todoCount,
    isPremium: isPremium,
  );

  return List.generate(itemCount, (index) {
    if (TodoListLayout.isAdSlot(index: index, isPremium: isPremium)) {
      return 'ad';
    }
    return 'todo${TodoListLayout.todoIndexFor(index: index, isPremium: isPremium)}';
  });
}
