import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/routes.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/extensions.dart';
import '../../data/bloc/todo_bloc.dart';
import '../../data/bloc/user_bloc.dart';
import '../../data/command/todo/todo_command.dart';
import '../../widgets/ads/ad_banner_widget.dart';
import '../../widgets/ads/ad_rewarded.dart';
import 'components/todo_tile.dart';

class TodoListLayout {
  static const int todosPerAd = 5;

  static int adSlotCount({required int todoCount, required bool isPremium}) {
    if (isPremium) return 0;
    return todoCount ~/ todosPerAd;
  }

  static int itemCount({
    required int todoCount,
    required bool isPremium,
    bool includeUpgradeBanner = false,
  }) {
    return todoCount +
        adSlotCount(todoCount: todoCount, isPremium: isPremium) +
        (includeUpgradeBanner ? 1 : 0);
  }

  static bool isAdSlot({required int index, required bool isPremium}) {
    if (isPremium || index < todosPerAd) return false;
    return (index + 1) % (todosPerAd + 1) == 0;
  }

  static int todoIndexFor({required int index, required bool isPremium}) {
    if (isAdSlot(index: index, isPremium: isPremium)) return -1;
    if (isPremium) return index;
    final adsBeforeIndex = (index + 1) ~/ (todosPerAd + 1);
    return index - adsBeforeIndex;
  }
}

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final cmd = TodoCommand();

    // Check if user can add for free
    if (!cmd.canAddTodoForFree()) {
      _showAdGateDialog(context, ref);
      return;
    }

    _showAddTodoBottomSheet(context);
  }

  void _showAddTodoBottomSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Add Todo',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                if (titleCtrl.text.isNotEmpty) {
                  TodoCommand().addTodo(titleCtrl.text, descCtrl.text);
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Todo'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showAdGateDialog(BuildContext context, WidgetRef ref) {
    AdRewarded.showWithConsent(
      context,
      title: 'Task Limit Reached',
      description:
          'Free users can have up to ${TodoCommand.freeTaskLimit} active tasks.\nWatch a short ad to add another task!',
      rewardText: 'Extra task slot unlocked',
      onRewarded: () {
        _showAddTodoBottomSheet(context);
      },
      onCancelled: () {
        // Show upgrade prompt
        if (context.mounted) {
          context.showSnackBar('Upgrade to Premium for unlimited tasks');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoBlocProvider);
    final user = ref.watch(userBlocProvider);
    final colorScheme = context.colorScheme;
    final cmd = TodoCommand();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
        actions: [
          // Free slots badge
          if (!user.isPremium)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cmd.canAddTodoForFree()
                        ? colorScheme.primaryContainer
                        : AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${cmd.remainingFreeSlots}/${TodoCommand.freeTaskLimit} free',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cmd.canAddTodoForFree()
                          ? colorScheme.onPrimaryContainer
                          : AppColors.warning,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: todosAsync.when(
        data: (todos) {
          final showUpgradeBanner = _shouldShowUpgradeBanner(
            cmd,
            user.isPremium,
          );
          final contentItemCount = TodoListLayout.itemCount(
            todoCount: todos.length,
            isPremium: user.isPremium,
          );

          if (todos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.checklist_rounded,
                    size: 80,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No todos yet',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap + to create your first todo',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: TodoListLayout.itemCount(
              todoCount: todos.length,
              isPremium: user.isPremium,
              includeUpgradeBanner: showUpgradeBanner,
            ),
            itemBuilder: (context, index) {
              // Upgrade banner at the end
              if (showUpgradeBanner && index == contentItemCount) {
                return _UpgradeBanner(
                  onTap: () => context.push(AppRoutes.premium),
                );
              }

              // Banner ad every 5 items (for free users)
              if (TodoListLayout.isAdSlot(
                index: index,
                isPremium: user.isPremium,
              )) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: AdBannerWidget(),
                );
              }

              final todoIndex = TodoListLayout.todoIndexFor(
                index: index,
                isPremium: user.isPremium,
              );
              if (todoIndex < 0 || todoIndex >= todos.length) {
                return const SizedBox.shrink();
              }
              return TodoTile(todo: todos[todoIndex]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  bool _shouldShowUpgradeBanner(TodoCommand cmd, bool isPremium) {
    return !isPremium && !cmd.canAddTodoForFree();
  }
}

// ── Upgrade Banner ────────────────────────────────────────────

class _UpgradeBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _UpgradeBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientStart.withValues(alpha: 0.08),
                  AppColors.gradientEnd.withValues(alpha: 0.08),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.premiumGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.diamond_rounded,
                    color: AppColors.premiumGold,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upgrade to Premium',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Unlimited tasks & no ads',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
